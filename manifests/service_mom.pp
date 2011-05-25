class torque::service_mom {

	file { '/etc/init.d/pbs_mom':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_sched'],
	}

	replace { 'ensure_torque_mom_path':
		file => '/etc/init.d/pbs_mom',
		pattern => "^DAEMON.*$",
		replacement => "DAEMON=${torque::params::install_dist}/sbin/pbs_mom",
		require => File['/etc/init.d/pbs_mom'],
	}

	service { 'pbs_mom':
		ensure => running,
		require => Line['ensure_torque_mom_path'],
	}

}

