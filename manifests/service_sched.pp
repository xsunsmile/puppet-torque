class torque::service_sched {

	file { '/etc/init.d/pbs_sched':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_sched'],
	}

	service { 'pbs_sched':
		ensure => running,
		require => [ Service['pbs_server'], Replace['ensure_torque_sched_path'] ]
	}

}


