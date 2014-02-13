class apache {
    include apache::params, apache::install, apache::config, apache::service 
} 
include apache
