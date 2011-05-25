
class torque::install {

	include torque::params

	exec { "install-torque":
		path => "/bin:/usr/bin:/usr/sbin",
		cwd => "/tmp/torque/torque",
		command => "make install",
		require => Exec['build-torque'],
		timeout => 0,
		unless => "ls ${torque::params::install_dist}",
	}

	file { '/etc/profile.d/torque.sh':
		ensure => present,
		owner => root,
		group => root,
		mode => 0755,
		content => template('torque/profiled.conf.erb'),
		require => Exec['install-torque'],
	}

	file { '/etc/ld.so.conf.d/torque.conf':
		ensure => present,
		content => "/opt/torque/lib",
		owner => root,
		group => root,
		mode => 0744,
		require => Exec['install-torque']
	}

	exec { 'ldconfig_torque':
		path => '/usr/sbin:/usr/bin:/sbin',
		command => 'ldconfig',
		require => File['/etc/ld.so.conf.d/torque.conf'],
	}

	exec { 'init_torque':
		cwd => "/tmp/torque/torque",
		path => "/tmp/torque/torque:/opt/torque/bin:/opt/torque/sbin:/bin:/usr/bin",
		command => "torque.setup ${torque::params::torque_admin}",
		require => [File['/etc/profile.d/torque.sh'], Exec['ldconfig_torque']],
		unless => 'ls /var/spool/torque/server_priv/serverdb',
	}

	exec { 'stop_server':
		path => "/opt/torque/bin:/opt/torque/sbin",
		command => "qterm -t quick || echo''",
		require => Exec['init_torque'],
	}

	file { '/var/spool/torque/checkpoint':
		ensure => directory,
		mode => 0755,
		owner => root,
		group => root,
		require => Exec['install-torque'],
	}

	exec { 'install_initd_server':
		path => "/usr/bin:/bin",
		command => "cp ${torque::params::torque_initd}/debian.pbs_server /etc/init.d/pbs_server",
		require => Exec['install-torque'],
	}

	exec { 'install_initd_sched':
		path => "/usr/bin:/bin",
		command => "cp ${torque::params::torque_initd}/debian.pbs_sched /etc/init.d/pbs_sched",
		require => Exec['install-torque'],
	}

	exec { 'install_initd_mom':
		path => "/usr/bin:/bin",
		command => "cp ${torque::params::torque_initd}/debian.pbs_mom /etc/init.d/pbs_mom",
		require => Exec['install-torque'],
	}

}
