#
class nginx( $document_root, $log_directory ) {

$nginx_default_vhost = "/etc/nginx/sites-enabled/default"

   package { "nginx":
       ensure => "latest"
   }

#   file { "/etc/nginx/sites-available/default":
#       	content => template("nginx/vhost_default.erb"),
#	require => Package["nginx"];
file {
	"/etc/nginx/conf.d/php_fpm.conf":
	 content => template("nginx/php_fpm.erb"),
	 require => Package["nginx"];

        $nginx_default_vhost:
        ensure => absent;
   }

   file { 
	"${log_directory}":
      	ensure => 'directory',
        mode    => 0755,
        owner   => www-data,
        group   => www-data,
	create_parents => true;
	
	"${document_root}":
	ensure => 'directory',
        mode    => 0755,
        owner   => www-data,
        group   => www-data,
	create_parents => true;
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
