class python::install {
 	package { python::params::python_package_name:
 		ensure => installed,
 	}
 }
