#!/bin/bash

#-------------------------------------------------------------------------------
# bin needed for script
#-------------------------------------------------------------------------------
RM=/bin/rm
CP=/bin/cp
MKDIR=/bin/mkdir
CHMOD=/bin/chmod
 
APT_GET=/usr/bin/apt-get
SERVICE=/usr/bin/service
SUDO=/usr/bin/sudo

ADDUSER=/usr/sbin/adduser

#-------------------------------------------------------------------------------
# default script config
#-------------------------------------------------------------------------------
#set e
deployment_dir=$1
webapp_name=$2
postgres_version='9.1'

#-------------------------------------------------------------------------------
# install postgres and create a new non-admin user
# called 'pguser' by default for our database admin stuff
# 
# Then create a database name that is set in the main 'deploy.sh'
#-------------------------------------------------------------------------------
$APT_GET install -y -qq postgresql

$ADDUSER --system pguser
$CHMOD -R 700 /home/pguser/

# change to postgres user and create our luser
$SUDO -u postgres createuser -D -E -l -S -R pguser
$SUDO -u postgres psql -U postgres -d postgres -c "alter user pguser with password 'thisisnotinthedictionary';"
$SUDO -u postgres createdb $webapp_name

$CP $deployment_dir/postgresql/pg_hba.conf /etc/postgresql/$postgres_version/main/pg_hba.conf

$SERVICE postgresql restart
