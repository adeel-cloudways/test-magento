#
class nginx( $document_root, $log_directory, $www_directory ) {
$nginx_default_vhost = "/etc/nginx/sites-enabled/default"
$magento_dirs = [ "${document_root}", "${log_directory}",
                ]

package { "nginx":
        ensure => "latest",
        }

file {
        $magento_dirs:
        ensure => "directory",
        owner  => "www-data",
        group  => "www-data",
        mode   => 0755,
        require => File [ "${www_directory}" ];

       "/etc/nginx/conf.d/php_fpm.conf":
        content => template("nginx/php_fpm.erb"),
        require => Package["nginx"];

        $nginx_default_vhost:
        ensure => absent;

        "${www_directory}":
        ensure => 'directory',
        mode    => 0755,
        owner   => www-data,
        group   => www-data,
     }

service { "nginx":
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        require => [ Package["nginx"], File ["/etc/nginx/conf.d/php_fpm.conf"] ];
        }

exec { "reload nginx":
        command => "/etc/init.d/nginx reload",
        require => [ Package["nginx"], File ["/etc/nginx/conf.d/php_fpm.conf"] ];
     }
}

