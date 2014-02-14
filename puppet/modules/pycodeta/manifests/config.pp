class pycodeta::config {
    # make sure our python wsgi gets there
    class { 'python':
        pip => true,
        dev => true,
        virtualenv => true,
    }

    python::virtualenv { '/srv/www/codeta/wsgi/codeta':
        ensure => present,
        requirements => '/var/git/puppet/codeta/puppet/modules/pycodeta/files/requirements.pip',
        systempkgs => false,
        cwd => '/srv/www/codeta/wsgi/codeta',
    }

    file { '/srv/www/codeta/wsgi/codeta.wsgi':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0444,
        source => 'puppet:///modules/pycodeta/codeta.wsgi',
    }

}
