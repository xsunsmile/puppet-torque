
class torque::service {

	include torque::params

	if $hostname == $torque::params::torque_master {
		include torque::service_server
		include torque::service_sched
	}
	include torque::service_mom

}

