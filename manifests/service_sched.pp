class torque::service_sched {

	include torque::install

	service { 'pbs_sched':
		ensure => running,
		require => [ Service['pbs_server'], Replace['ensure_torque_sched_path'] ]
	}

}


