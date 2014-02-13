class apache::params { 
 	case $operatingsystem { 
 		Solaris: { 
            $apache_package_name = 'apache2'
            $apache_service_config = '/etc/apache2/apache2.conf'
            $apache_service_name = 'apache2'
            $apache_site_config = '/etc/apache2/sites-enabled/codeta.conf'
            $apache_wsgi_config = '/etc/apache2/mods-enabled/wsgi.conf'

 		} 
 		/(Ubuntu|Debian)/: { 
            $apache_package_name = 'apache2'
            $apache_service_config = '/etc/apache2/apache2.conf'
            $apache_service_name = 'apache2'
            $apache_site_config = '/etc/apache2/sites-enabled/codeta.conf'
            $apache_wsgi_config = '/etc/apache2/mods-enabled/wsgi.conf'

 		} 
 		/(RedHat|Fedora|CentOS)/: { 
            $apache_package_name = 'apache2'
            $apache_service_config = '/etc/apache2/apache2.conf'
            $apache_service_name = 'apache2'
            $apache_site_config = '/etc/apache2/sites-enabled/codeta.conf'
            $apache_wsgi_config = '/etc/apache2/mods-enabled/wsgi.conf'

 		} 
 	} 
 }
