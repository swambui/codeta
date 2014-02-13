class apache::install {
 	package { $apache::params::apache_package_name:
 		ensure => installed,
 	}

    package { 'libapache2-mod-wsgi':
        ensure => installed,
    }
 }
