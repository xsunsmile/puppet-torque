class torque::service_sched {

	file { '/etc/init.d/pbs_sched':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_sched'],
	}

	replace { 'ensure_torque_sched_path':
		file => '/etc/init.d/pbs_sched',
		pattern => "^DAEMON.*$",
		replacement => "DAEMON=${torque::params::install_dist}/sbin/pbs_sched",
		require => File['/etc/init.d/pbs_sched'],
	}

	service { 'pbs_sched':
		ensure => running,
		require => [ Service['pbs_server'], Line['ensure_torque_sched_path'] ]
	}

}


