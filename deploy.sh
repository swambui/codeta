#!/bin/bash

# Deploys the application to a server, installing all the necessary components
# Two main parts, deploying of the server infrastructure for the webapp
# and deploying the webapp itself

# Run 'deploy.sh server'
# to install the webserver, database server, python dependencies
# should only have to do this once unless you update the server configurations

# Run 'deploy.sh webapp'
# to update the webapp with the files in your currently checked out git repo


#-------------------------------------------------------------------------------
# bin for the script
#-------------------------------------------------------------------------------
BASH=/bin/bash;
CP=/bin/cp;
RM=/bin/rm;
ECHO=/bin/echo;
MKDIR=/bin/mkdir;

APT_GET=/usr/bin/apt-get;

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

function deploy_server {
    # set up and run our puppet stuff
    apt-get install puppet
    git clone https://www.github.com/bmoar/codeta.git /var/git/puppet/codeta
    cp $git_dir/puppet/files/puppet.conf /etc/puppet/puppet.conf
    puppet apply $git_dir/puppet/manifests/bootstrap.pp
    chown -R git /var/git/puppet/codeta/
}

function deploy_puppet {
    # pull codeta repo and run puppet
    cd /var/git/puppet/codeta/
    git pull
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
        deploy_server
        deploy_puppet
        deploy_webapp
        ;;
    puppet)
        deploy_puppet
        ;;
    server)
        deploy_server
        ;;
    webapp)
        deploy_webapp
        ;;
    *)
        usage
esac
