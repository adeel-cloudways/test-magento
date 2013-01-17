group { "puppet":
    ensure => "present",
}

class { "nginx":
    document_root => "/var/www/web/",
    log_directory => "/var/www/logs/"
}

class { "params":
    document_root => "/var/www/web/",
    log_directory => "/var/www/logs/"
}


/**
 * Import modules
 */
include apt
include params
#include mysql
include nginx
include php5
include magento
