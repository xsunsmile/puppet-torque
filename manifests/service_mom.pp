class torque::service_mom {

	include torque::install

	file { "${torque::params::spool_dir}/mom_priv/config":
		ensure => present,
		owner => root,
		group => root,
		mode => 744,
		content => template('torque/mom_config.erb'),
		require => Exec['install-torque'],
	}

	service { 'pbs_mom':
		ensure => running,
		require => Replace['ensure_torque_mom_path'],
	}

}

