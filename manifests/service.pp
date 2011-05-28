
class torque::service {

	include torque::params

	replace { 'turn_on_verbose':
		file => '/etc/default/rcS',
		pattern => '^VERBOSE.*$',
		replacement => 'VERBOSE=yes',
	}

	if $hostname == $torque::params::torque_master {
		include torque::service_server
		include torque::service_sched
	}
	include torque::service_mom
	include torque::service_test

}

