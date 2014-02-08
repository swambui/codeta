#!/bin/bash

#-------------------------------------------------------------------------------
# bin needed for script
#-------------------------------------------------------------------------------
RM=/bin/rm
CP=/bin/cp
MKDIR=/bin/mkdir
CHMOD=/bin/chmod

ADDUSER=/usr/sbin/adduser
 
APT_GET=/usr/bin/apt-get
INITD=/etc/init.d/postgresql
SUDO=/usr/bin/sudo

#-------------------------------------------------------------------------------
# default script config
#-------------------------------------------------------------------------------
postgres_version='9.1'

database_user='pguser'
default_password='default'

#-------------------------------------------------------------------------------
# install postgres and create a new non-admin user
# 
# Then create a database name that is set in the main 'deploy.sh'
#-------------------------------------------------------------------------------
$APT_GET install -y -qq postgresql postgresql-server-dev-all libpg-dev

$ADDUSER --system $database_user
$CHMOD -R 600 /home/$database_user/

# change to postgres user and create our luser
$SUDO -u postgres createuser -D -E -l -S -R $database_user
$SUDO -u postgres psql -U postgres -d postgres -c "alter user $database_user with password '$default_password';"
$SUDO -u postgres createdb $app

# create test database
$SUDO -u postgres createdb $app"_test"

$CP $deployment_dir/postgresql/pg_hba.conf /etc/postgresql/$postgres_version/main/pg_hba.conf

$INITD restart
