class postgres::install {
 	package { postgres::params::postgres_package_name:
 		ensure => installed,
 	}
 }
