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

#-------------------------------------------------------------------------------
# default script config
#-------------------------------------------------------------------------------
set e

$APT_GET install -y -qq libapache2-mod-wsgi python-psycopg2 build-essential python-pip 

# install python packages
$PIP install flask flask-login passlib sqlalchemy

# set up virtualenv here
