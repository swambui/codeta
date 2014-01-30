#!/bin/bash

# installs and configures apache to run


#-------------------------------------------------------------------------------
# bin needed for script
#-------------------------------------------------------------------------------
RM=/bin/rm
CP=/bin/cp
CHMOD=/bin/chmod
 
APT_GET=/usr/bin/apt-get
INITD=/etc/init.d/apache2

#-------------------------------------------------------------------------------
# default script config
#-------------------------------------------------------------------------------
apache_dir=/etc/apache2 #TODO make this not distro specific
set e

#-------------------------------------------------------------------------------
# removes the default apache config and enables our new webapp site
#-------------------------------------------------------------------------------
$APT_GET install -y -qq apache2 libapache2-mod-wsgi

$RM $apache_dir/sites-enabled/000-default
$CP $deployment_dir/apache/$app.conf $apache_dir/sites-enabled/$app.conf

$INITD reload

$INITD start
