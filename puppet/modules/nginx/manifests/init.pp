#
class nginx( $document_root, $log_directory, $www_directory ) {

$nginx_default_vhost = "/etc/nginx/sites-enabled/default"
$magento_dirs=[ "${www_directory}", "${log_directory}"]

   package { "nginx":
       ensure => "latest"
   }

file {
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

file {
	"${magento_dirs}":
	require => File["${www_directory}"],
        ensure => 'directory',
        mode    => 0755,
        owner   => www-data,
        group   => www-data,
}

#   file { 
#	"${log_directory}":
#      	ensure => 'directory',
#        mode    => 0755,
#        owner   => www-data,
#        group   => www-data,
	
#	"${document_root}":
#	ensure => 'directory',
#        mode    => 0755,
#        owner   => www-data,
#        group   => www-data;
#   }

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
