
class torque::service_server {

	file { '/etc/init.d/pbs_server':
		ensure => present,
		owner => root,
		group => root,
		mode => 755,
		require => Exec['install_initd_server'],
	}

	file { "${spool_dir}/server_priv/nodes":
		ensure => present,
		require => Exec['init_torque'],
	}

	replace { 'ensure_torque_server_path':
		file => '/etc/init.d/pbs_server',
		pattern => "^DAEMON.*$",
		replacement => "DAEMON=${torque::params::install_dist}/sbin/pbs_server",
	}

	cron { 'add_new_hosts':
		path => '/usr/bin:/bin:/usr/sbin',
		command => '/usr/bin/mongo_host sync_to_torque',
		minute => 5,
	}

	service { 'start_pbs_server':
		name => 'pbs_server',
		ensure => running,
		require => [ Replace['ensure_torque_server_path'], Exec['stop_server'] ],
		subscribe => File["${spool_dir}/server_priv/nodes"],
	}

}


