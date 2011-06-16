
class torque::service_test_master inherits torque::service_test {

	include torque::service_server

	exec { 'restart_pbs_server':
		path => "/usr/bin:/usr/sbin:/bin:${torque::params::install_dist}/bin:${torque::params::install_dist}/sbin",
		command => "/etc/init.d/pbs_server restart",
		require => Service['start_pbs_server'],
		onlyif => "ls /etc/init.d/pbs_server",
	}
	Exec['test-qsub'] {
		require +> [
			Service['start_pbs_server'],
			Exec['restart_pbs_server'],
		],
	}

}
