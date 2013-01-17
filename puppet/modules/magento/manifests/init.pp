#
class magento inherits params{

   file { 
	"/etc/nginx/sites-available/magento":
        content => template("magento/vhost_magento.erb"),
	require => Class[nginx];

	"/etc/nginx/sites-enabled/magento":
     	ensure => 'link',
     	target => '/etc/nginx/sites-available/magento';
   }

   exec { "reload-nginx":
      	command => "/etc/init.d/nginx reload",
      	require => [ Package["nginx"], File ["/etc/nginx/sites-enabled/magento"] ];
   }

  exec { "download-magento":
    cwd => "/tmp",
    command => "wget http://www.magentocommerce.com/downloads/assets/1.7.0.2/magento-1.7.0.2.tar.gz",
    path    => "/usr/local/bin/:/bin/:/usr/bin/:",
    creates => "/tmp/magento-1.7.0.2.tar.gz";
  }

  exec { 
    "untar-magento":
    cwd => "$document_root",
    command => "tar xvzf /tmp/magento-1.7.0.2.tar.gz --strip-components=1",
    path    => "/usr/local/bin/:/bin/:/usr/bin/:",
    require => Exec["download-magento"];

    "setting-dir-permissions":
    cwd => "$document_root",
    command => "find . -type d  -exec chmod 755 {} '\\;'",
    path    => "/usr/local/bin/:/bin/:/usr/bin/:",
    require => Exec["untar-magento"];

    "setting-file-permissions":
    cwd => "$document_root",
    command => "find . -type f  -exec chmod 644 {} '\\;'",
    path    => "/usr/local/bin/:/bin/:/usr/bin/:",
    require => Exec["untar-magento"];

    "setting-ownership":
    cwd => "$document_root",
    command => "chown -R www-data:www-data '${document_root}'",
    path    => "/usr/local/bin/:/bin/:/usr/bin/:",
    require => Exec["untar-magento"];



  }

}
