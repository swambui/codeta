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

function deploy_server {
    # make sure we upgrade before we do things
    $APT_GET update
    $APT_GET upgrade

    # create needed directories
    $MKDIR -p $webapp_dir
    $MKDIR -p $webapp_root_dir
    $MKDIR -p $webapp_log_dir

    # run deployment scripts for our programs
    programs=(
        'apache'
        'postgresql'
        'python'
    )

    for i in "${programs[@]}"
    do
        $BASH $git_dir/deployment/$i/install.sh
    done
}

function deploy_webapp {
    # Remove all python components and reinstall from github directory
    if [ -d $webapp_dir/$app ] ; then
        $RM -rf $webapp_dir/$app/
    fi
    $CP -r $git_dir/$app/ $webapp_dir/
}

function usage {
    $ECHO "usage: deploy.sh (all | webapp | server)"
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
        deploy_webapp
        ;;
    webapp)
        deploy_webapp
        ;;
    server)
        deploy_server
        ;;
    *)
        usage
esac
