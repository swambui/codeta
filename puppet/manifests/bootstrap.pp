user { 'git':
    ensure => 'present',
    home => '/var/git',
}

file {
    '/var/git':
    ensure => directory,
    owner => git,
    require => User['git'];

    '/var/git/puppet':
    ensure => directory,
    owner => git,
    require => [User['git'], File['/var/git']];

}

package { 'git':
    ensure => present,
}

exec { 'Pull codeta repo':
    cwd => '/var/git/puppet/',
    user => 'git',
    command => '/usr/bin/git clone https://github.com/bmoar/codeta.git',
    creates => '/var/git/puppet/codeta/.git/HEAD',
    require => [File['/var/git/puppet'], Package['git'], User['git']],
}
