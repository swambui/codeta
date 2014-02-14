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
