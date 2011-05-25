class torque::compile {
	
	package { "build-essential": ensure => installed }

	file { "/tmp/torque":
		ensure => directory,
		owner => root,
		group => root,
		mode => 0777,
	}

	file { "/tmp/torque/fetch.sh":
		ensure => present,
		owner => root,
		group => root,
		mode => 0755,
		source => "puppet:///torque/fetch.sh",
		require => File['/tmp/torque'],
	}

	exec { "download":
		cwd => "/tmp/torque",
		command => "/bin/sh fetch.sh",
		unless => "ls /tmp/torque/torque",
		require => File['/tmp/torque/fetch.sh'],
	}

	file { "/tmp/torque/torque":
		ensure => directory,
		mode => 0777,
		require => Exec['download'],
	}

	exec { "configure-torque":
		path => "/bin:/usr/bin:/usr/sbin",
		cwd => "/tmp/torque/torque",
		command => "sh configure ${compile_args}",
		require => File['/tmp/torque/torque'],
		unless => "ls ${torque::params::install_dist}",
	}

	exec { "build-torque":
		path => "/bin:/usr/bin:/usr/sbin",
		cwd => "/tmp/torque/torque",
		command => "make",
		require => Exec['configure-torque'],
		timeout => 0,
		unless => "ls ${torque::params::install_dist}",
	}

}
