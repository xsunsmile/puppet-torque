
class torque::service_server {

	file { "${torque::params::spool_dir}/server_priv/nodes":
		ensure => present,
		require => Exec['init_torque'],
	}

	cron { 'add_new_hosts':
		ensure => present,
		user => root,
		command => '/usr/bin/mongo_host sync_to_torque || true',
		minute => "*/2",
	}

	service { 'start_pbs_server':
		name => 'pbs_server',
		ensure => running,
		require => [ Replace['ensure_torque_server_path'], Exec['stop_server'] ],
		subscribe => File["${torque::params::spool_dir}/server_priv/nodes"],
	}

	exec { 'set_autodetect_np':
		path => "${torque::params::install_dist}/bin:${torque::params::install_dist}/sbin",
		command => "qmgr -c 'set server auto_node_np = True'",
		require => [ Service['start_pbs_server'], File["${torque::params::spool_dir}/server_priv/nodes"] ]
	}

	exec { 'set_node_submit_ok':
		path => "${torque::params::install_dist}/bin:${torque::params::install_dist}/sbin",
		command => "qmgr -c 'set server allow_node_submit = True'",
		require => [ Service['start_pbs_server'], File["${torque::params::spool_dir}/server_priv/nodes"] ]
	}

}


