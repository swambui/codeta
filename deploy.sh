#!/bin/bash

# Deploys the application to a server, installing all the necessary components

#-------------------------------------------------------------------------------
# bin for the script
#-------------------------------------------------------------------------------
BASH=/bin/bash;
CP=/bin/cp;
RM=/bin/rm;
ECHO=/bin/echo;
MKDIR=/bin/mkdir;
CHOWN=/bin/chown;

APT_GET=/usr/bin/apt-get;
GIT=/usr/bin/git;

#-------------------------------------------------------------------------------
# default configuration
#-------------------------------------------------------------------------------

# dir name for the source code in the git dir
export app='codeta'

# directory configs
# dir where the cloned repo is. Automatically generated when you run deploy.sh
export git_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export deployment_dir=$git_dir/deployment

# webserver configs
export webserver_dir=/srv/www
export webapp_dir=$webserver_dir/$app/wsgi
export webapp_root_dir=$webserver_dir/$app/root

# python configs

# logging configs
export deploy_log_dir=$git_dir/deploy.log
export webapp_log_dir=$webserver_dir/$app/log


#-------------------------------------------------------------------------------
# main functions of the script
#-------------------------------------------------------------------------------

function deploy_webapp {
    # Remove all python components and reinstall from github directory

    # filter out python virtualenv files
    for file in $(ls $webapp_dir/$app | grep -Ev '^(bin|include|lib|local)$')
    do
        $RM -rf $webapp_dir/$app/$file
    done

    $CP -r $git_dir/$app/ $webapp_dir/
}

function deploy_bootstrap {
    # set up and run our puppet stuff
    $APT_GET install -y puppet
    $GIT clone https://www.github.com/bmoar/codeta.git /var/git/puppet/codeta
    $CP $git_dir/puppet/files/puppet.conf /etc/puppet/puppet.conf
    puppet apply $git_dir/puppet/manifests/bootstrap.pp
    $CHOWN -R git /var/git/puppet/codeta/
}

function deploy_puppet {
    # pull codeta repo and run puppet
    cd /var/git/puppet/codeta/
    $GIT pull
    puppet apply /var/git/puppet/codeta/puppet/manifests/site.pp
}

function usage {
    $ECHO "usage: deploy.sh (all | puppet | server | webapp)"
    exit
}

# Make sure we are running as root
if [[ $(id -u) -ne 0 ]] ; then $ECHO "Please run as root" ; exit 1 ; fi

user_args=$1
set e
# check main deployment opt
case $user_args in
    all)
        deploy_bootstrap
        deploy_puppet
        deploy_webapp
        ;;
    puppet)
        deploy_puppet
        ;;
    bootstrap)
        deploy_bootstrap
        ;;
    webapp)
        deploy_webapp
        ;;
    *)
        usage
esac
