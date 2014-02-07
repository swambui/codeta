#!/bin/bash
#-------------------------------------------------------------------------------
# bin needed for script
#-------------------------------------------------------------------------------
RM=/bin/rm
CP=/bin/cp
MKDIR=/bin/mkdir
CHMOD=/bin/chmod
 
APT_GET=/usr/bin/apt-get

PIP=/usr/local/bin/pip

VIRT_PIP=$webapp_dir/$app/bin/pip
VIRTENV=/usr/local/bin/virtualenv

#-------------------------------------------------------------------------------
# default script config
#-------------------------------------------------------------------------------
set e

#-------------------------------------------------------------------------------
# do it
#-------------------------------------------------------------------------------

$APT_GET install -y -qq libapache2-mod-wsgi python-psycopg2 build-essential \
    python-pip libpq-dev python-dev

# install python packages
$PIP install -q virtualenv

$VIRTENV $webapp_dir/$app

#$VIRT_PIP install flask flask-login passlib sqlalchemy 
$VIRT_PIP install -q -r $deployment_dir/python/requirements.pip
