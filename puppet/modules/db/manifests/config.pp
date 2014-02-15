class db::config {
    user { 'pguser':
        ensure => present,
    }

    class { 'postgresql::globals':
        pg_hba_conf_defaults => false,
    }

    class { 'postgresql::server': }

    # override defaults in postgresql::globals
    postgresql::server::pg_hba_rule {
        'local access as prostgres user':
        type => 'local',
        database => 'all',
        user => 'postgres',
        auth_method => 'ident',
    }

    postgresql::server::pg_hba_rule {
        'allow access over unix socket for codeta':
        description => 'Open up access to pguser from psycopg2',
        type => 'local',
        database => 'codeta',
        user => 'pguser',
        auth_method => 'md5',
    }

    postgresql::server::pg_hba_rule {
        'allow access over unix socket for codeta_test':
        description => 'Open up access to pguser from psycopg2',
        type => 'local',
        database => 'codeta_test',
        user => 'pguser',
        auth_method => 'md5',
        order => 2,
    }

    postgresql::server::pg_hba_rule {
        'allow localhost TCP access to postgres user':
        type => 'host',
        database => 'all',
        user => 'postgres',
        address => '127.0.0.1/32',
        auth_method => 'md5',
    }

    postgresql::server::pg_hba_rule {
        'deny TCP access to postgres user not on localhost':
        type => 'host',
        database => 'all',
        user => 'postgres',
        address => '0.0.0.0/0',
        auth_method => 'reject',
    }

    postgresql::server::pg_hba_rule {
        'allow localhost TCP access to all users':
        type => 'host',
        database => 'all',
        user => 'all',
        address => '127.0.0.1/32',
        auth_method => 'md5',
    }

    postgresql::server::pg_hba_rule {
        'allow localhost ipv6 TCP access to all users':
        type => 'host',
        database => 'all',
        user => 'all',
        address => '::1/128',
        auth_method => 'md5',
    }

    postgresql::server::role { 'pguser':
        password_hash => postgresql_password('pguser', 'default'),
        require => Class['db::install'],
    }

    postgresql::server::db { 'codeta':
        user => 'pguser',
        password => postgresql_password('pguser', 'default'),
        owner => 'pguser',
        require => [Class['db::install'], 'pguser'],
    }

    postgresql::server::db { 'codeta_test':
        user => 'pguser',
        password => postgresql_password('pguser', 'default'),
        owner => 'pguser',
        require => [Class['db::install'], 'pguser'],
    }

}
