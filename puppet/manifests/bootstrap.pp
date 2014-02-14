user { 'git':
    ensure => 'present',
    home => '/var/git',
}

file {
    '/var/git':
    ensure => directory,
    owner => 'git',
    require => User['git'];

    '/var/git/puppet':
    ensure => directory,
    owner => 'git',
    require => [User['git'], File['/var/git']];

}

package { 'git':
    ensure => present,
}

exec { 'Change puppet config':
    user => 'root',
    command => '/bin/cp /var/git/puppet/codeta/puppet/files/puppet.conf /etc/puppet/puppet.conf',
    creates => '/etc/puppet/puppet.conf',
}
