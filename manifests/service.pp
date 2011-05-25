
class torque::service {

	include torque::params

	if $hostname == $torque::params::torque_master {
		include torque::service::server
		include torque::service::sched
	}
	include torque::service::mom
}

class torque::service::server {

	file { '/etc/init.d/pbs_server':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_server'],
	}

	service { 'pbs_server':
		ensure => running,
		require => Exec['stop_server'],
	}

}

class torque::service::sched {

	file { '/etc/init.d/pbs_sched':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_sched'],
	}

	service { 'pbs_sched':
		ensure => running,
	}

}

class torque::service::mom {

	file { '/etc/init.d/pbs_mom':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_sched'],
	}

	service { 'pbs_mom':
		ensure => running,
	}

}

