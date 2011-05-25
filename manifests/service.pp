
class torque::service {

	include torque::params
	notify {"master is ${torque::params::torque_master}, this ${hostname}":}
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

	line { 'ensure_torque_server_path':
		file => '/etc/init.d/pbs_server',
		line => "DAEMON=${torque::params::install_dir}/sbin/$NAME",
	}

	service { 'pbs_server':
		ensure => running,
		require => Line['ensure_torque_server_path'],
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

	line { 'ensure_torque_sched_path':
		file => '/etc/init.d/pbs_sched',
		line => "DAEMON=${torque::params::install_dir}/sbin/$NAME",
		require => File['/etc/init.d/pbs_sched'],
	}

	service { 'pbs_sched':
		ensure => running,
		require => [ Service['pbs_server'], Line['ensure_torque_sched_path'] ]
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

	line { 'ensure_torque_mom_path':
		file => '/etc/init.d/pbs_mom',
		line => "DAEMON=${torque::params::install_dir}/sbin/$NAME",
		require => File['/etc/init.d/pbs_mom'],
	}

	service { 'pbs_mom':
		ensure => running,
		require => Line['ensure_torque_mom_path'],
	}

}

