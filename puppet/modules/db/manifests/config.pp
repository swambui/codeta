class db::config {
    class { 'postgresql::globals':
        pg_hba_conf_defaults => false,
    }

    class { 'postgresql::server': }

    postgresql::server::db { 'codeta':
        user => 'pguser',
        password => postgresql_password('pguser', 'default'),
        owner => 'pguser',
        require => Class['db::role'],
    }

    postgresql::server::db { 'codeta_test':
        user => 'pguser',
        password => postgresql_password('pguser', 'default'),
        owner => 'pguser',
        require => Class['db::role'],
    }

}
