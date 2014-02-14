class db::install {
    package { 'postgresql':
        ensure => installed,
    }

    package { 'postgresql-server-dev-all':
        ensure => installed,
    }

    user { 'pguser':
        ensure => present,
    }
 }
