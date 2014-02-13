class db::install {
 	#package { $db::params::db_package_name:
 	#	ensure => installed,
 	#}
    package { 'postgresql':
        ensure => installed,
    }
 }
