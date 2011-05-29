
class torque::service_test {

	file { '/tmp/torque/test.sh':
		ensure => present,
		owner => root,
		group => root,
		mode => 0755,
		content => template("torque/test.sh.erb"),
		require => File['/tmp/torque'],
	}

	exec { 'restart_pbs_server':
		path => "/usr/bin:/usr/sbin:/bin:${torque::params::install_dist}/bin:${torque::params::install_dist}/sbin",
		command => "/etc/init.d/pbs_server restart",
		require => Service['start_pbs_server'],
		onlyif => "pbsnodes -a",
	}

	exec { 'test-qsub':
		cwd => "/tmp/torque",
		path => "${torque::params::install_dist}/bin:${torque::params::install_dist}/sbin",
		command => "qsub test.sh",
		require => [
			File['/tmp/torque/test.sh'],
			Exec['restart_pbs_server'],
		],
		tries => 3,
		try_sleep => 60,
	}

}