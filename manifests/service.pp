
class torque::service {

	file { '/etc/init.d/torque_server':

	}

	file { '/etc/init.d/torque_sched':

	}

	file { '/etc/init.d/torque_mon':

	}

	service { 'torque_server':

	}

}
