
class torque::service_test {

	include torque::compile
	include torque::service_mom

	$torque_user_not_root = extlookup("torque_user_not_root")

	file { "${torque::params::install_src}/test.sh":
		ensure => present,
		owner => root,
		group => root,
		mode => 0755,
		content => template("torque/test.sh.erb"),
		require => File["${torque::params::install_src}"],
	}

	exec { 'test-qsub':
		cwd => "${torque::params::install_src}",
		path => "/usr/bin:/bin",
		user => "${torque_user_not_root}",
		command => "${torque::params::install_dist}/bin/qsub -l host=${hostname} test.sh",
		require => [
			File['/tmp/torque/test.sh'],
			Service['pbs_mom'],
		],
		tries => 3,
		try_sleep => 1,
	}

}

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
		onlyif => "ps aux | grep pbs_server",
	}

}
