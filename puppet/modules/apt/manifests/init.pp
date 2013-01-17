class apt {
#         refreshonly => true,
	exec { 'run apt-get':
                command => "apt-get update",
                path    => "/usr/local/bin/:/bin/:/usr/bin/:",
	}

	package { "python-software-properties":
    	ensure => "present",
	require => Exec['run apt-get'];
	}

        exec { 'add repo':
                command => "add-apt-repository ppa:nginx/stable",
                path    => "/usr/local/bin/:/bin/:/usr/bin/:",
		require => Package['python-software-properties'];
                
		'apt-get update':
                command => "apt-get update",
                path    => "/usr/local/bin/:/bin/:/usr/bin/:",
                require => Exec['add repo'];
        }

}
