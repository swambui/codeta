class apache::config {

    file { $apache::params::apache_service_config:
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0440,
        source => 'puppet:///modules/apache/apache2.conf',
        require => Class['apache::install'],
        notify => Class['apache::service'],
 	}

    file { $apache::params::apache_site_config:
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0440,
        source => 'puppet:///modules/apache/codeta.conf',
        require => Class['apache::install'],
        notify => Class['apache::service'],
 	}

    file { $apache::params::apache_wsgi_config:
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0440,
        source => 'puppet:///modules/apache/wsgi.conf',
        require => Class['apache::install'],
        notify => Class['apache::service'],
 	}

    file { ['/srv/', '/srv/www/', '/srv/www/codeta/']:
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 0440,
    }

    file { '/srv/www/codeta/log':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 0440,
    }

    file { '/srv/www/codeta/wsgi':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 0444,
    }

    file { '/srv/www/codeta/root':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 0444,
    }
}
