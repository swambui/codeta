#!/bin/bash

# installs and configures apache to run


#-------------------------------------------------------------------------------
# bin needed for script
#-------------------------------------------------------------------------------
RM=/bin/rm
CP=/bin/cp
MKDIR=/bin/mkdir
CHMOD=/bin/chmod
 
APT_GET=/usr/bin/apt-get
INITD=/etc/init.d/apache2

#-------------------------------------------------------------------------------
# default script config
#-------------------------------------------------------------------------------
apache_dir='/etc/apache2'

deployment_dir=$1
webapp_name=$2
set e

#-------------------------------------------------------------------------------
# removes the default apache config and enables our new webapp site
#-------------------------------------------------------------------------------
$APT_GET install -y -qq apache2 libapache2-mod-wsgi

$RM $apache_dir/sites-enabled/000-default
$CP $deployment_dir/apache/$webapp_name.conf $apache_dir/sites-enabled/$webapp_name.conf

$INITD apache2 reload

$MKDIR -p /srv/www/$webapp_name/root/
$MKDIR -p /srv/www/$webapp_name/wsgi/
$MKDIR -p /srv/www/$webapp_name/log/

$CHMOD -R 777 /srv/www/$webapp_name/
