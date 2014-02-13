class sudo::sudoers {

    file { '/tmp/sudoers':
        mode => 440,
        source => 'puppet:///modules/sudo/files/sudoers',
        notify => Exec['check_sudoers'],
    }

    exec { 'check_sudoers':
        command => '/usr/sbin/visudo -cf /tmp/sudoers && cp /tmp/sudoers /etc/sudoers',
        refreshonly => true,
    }
}
