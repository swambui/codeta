class db::role {
    postgresql::server::role { 'pguser':
        password_hash => postgresql_password('pguser', 'default'),
        require => Class['db::install'],
    }
}
