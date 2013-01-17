class php5 {
        $php_packagelist = [ "php5-mysql", "php5-gd", "php5-mcrypt ,"php5-curl", "php-apc", "php5-dev", "php-pear", "php5-imagick", "php5-memcache", "make" ]
        $phpfpm_conf = "/etc/php5/fpm/pool.d/www.conf"

        package {'php5-fpm':
                ensure => latest,
                require => Package['nginx'];

                $php_packagelist:
                ensure => latest,
                require => Package[php5-fpm];
        }

        file { $phpfpm_conf:
                owner   => root,
                group   => root,
                mode    => 644,
                ensure  => present,
                content  => template("php5/www.conf.erb"),
                require => Package[php5-fpm];
        }

service { "php5-fpm":
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        require => File ["$phpfpm_conf"];
        }

}
