/*
    Sets up and maintains the 
    openssh-server service
*/

class ssh {
    include ssh::params, ssh::install, ssh::config, ssh::service
}

include ssh
