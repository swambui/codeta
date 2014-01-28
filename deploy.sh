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
BASH=/bin/bash;
CP=/bin/cp;
RM=/bin/rm;
ECHO=/bin/echo;


#-------------------------------------------------------------------------------
# default configuration
#

# dir name for the source code in the git dir
app='codeta'

# dir where the cloned repo is. Automatically generated when you run deploy.sh
git_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# webserver directory for the webapp source code
webapp_dir='/srv/www/'$app'/wsgi'


function deploy_server {
    # run deployment scripts for our programs
    programs=(
        'apache'
        'postgresql'
        'python'
    )
    for i in "${programs[@]}"
    do
        $BASH $git_dir/deployment/$i/install.sh $git_dir/deployment $app
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
