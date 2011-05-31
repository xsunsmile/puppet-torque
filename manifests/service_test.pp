
class torque::service_test {

	include torque::service_mom
	$torque_user_not_root = extlookup("torque_user_not_root")

	file { "${torque::params::install_src}/test.sh":
		ensure => present,
		owner => root,
		group => root,
		mode => 0755,
		content => template("torque/test.sh.erb"),
		require => Service['pbs_mom'],
	}

	exec { 'test-qsub':
		cwd => "${torque::params::install_src}",
		path => "/usr/bin:/bin",
		command => "sudo -u ${torque_user_not_root} ${torque::params::install_dist}/bin/qsub -l host=${hostname} test.sh",
		require => [
			File['/tmp/torque/test.sh'],
			Service['pbs_mom'],
		],
		tries => 3,
		try_sleep => 1,
	}

}


