class torque::compile {
	
	package { "build-essential": ensure => installed }

	$torque_admin = $user_torque_admin ? {
		'' => 'root',
		default => $user_torque_admin,
	}

	$compile_args = $user_compile_args ? {
		'' => "--prefix=/opt/torque --enable-drmaa ${user_compile_args}",
		default => $user_compile_args,
	}

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
					unless => "ls /opt/torque",
	}

	exec { "build-torque":
					path => "/bin:/usr/bin:/usr/sbin",
					cwd => "/tmp/torque/torque",
					command => "make",
					require => Exec['configure-torque'],
					timeout => 0,
					unless => "ls /opt/torque",
	}

	exec { "install-torque":
					path => "/bin:/usr/bin:/usr/sbin",
					cwd => "/tmp/torque/torque",
					command => "make install",
					require => Exec['build-torque'],
					timeout => 0,
					unless => "ls /opt/torque",
	}

	file { '/etc/profile.d/torque.sh':
		ensure => present,
		content => 'export PATH=$PATH:/opt/torque/bin:/opt/torque/sbin',
		owner => root,
		group => root,
		mode => 0755,
		require => Exec['install-torque'],
	}

	exec { 'init':
		path => "/opt/torque/bin:/opt/torque/sbin:/bin:/usr/bin",
		command => "torque.setup ${torque_admin}",
		require => File['/etc/profile.d/torque.sh'],
		unless => 'ps aux | grep pbs_server',
	}

	exec { 'stop_server':
		path => "/opt/torque/bin:/opt/torque/sbin",
		command => "qterm -t quick",
		require => Exec['init'],
	}

	exec { 'start_server':
		path => "/opt/torque/bin:/opt/torque/sbin",
		command => "pbs_server",
		require => Exec['stop_server'],
	}

}
