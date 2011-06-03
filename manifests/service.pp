
class torque::service {

	include torque::params
	$mongodb_host = extlookup('mongodb_host')
	$master_arch = mongolookup("mongodb://${mongodb_host}:27017/inters_hosts/hosts/${torque::params::torque_master}/arch")

	replace { 'turn_on_verbose':
		file => '/etc/default/rcS',
		pattern => '^VERBOSE.*$',
		replacement => 'VERBOSE=yes',
	}

	if $hostname == $torque::params::torque_master {
		include torque::service_server
		include torque::service_sched
		include torque::service_mom_master
		include torque::service_test_master
	} else {
		if $architecture != $master_arch {
			include torque::service_mom_master
			include torque::service_test_master
		} else {
			include torque::service_mom_node
			include torque::service_test
		}
	}

}

