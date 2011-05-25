
class torque::service_server {

	file { '/etc/init.d/pbs_server':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_server'],
	}

	replace { 'ensure_torque_server_path':
		file => '/etc/init.d/pbs_server',
		pattern => "^DAEMON.*$",
		replacement => "DAEMON=${torque::params::install_dist}/sbin/pbs_server",
	}

	service { 'start_pbs_server':
		name => 'pbs_server',
		ensure => running,
		require => [ Replace['ensure_torque_server_path'], Exec['stop_server'] ]
	}

}


