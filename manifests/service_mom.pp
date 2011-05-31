class torque::service_mom {

	file { "${torque::params::spool_dir}/mom_priv/config":
		ensure => present,
		owner => root,
		group => root,
		mode => 744,
		content => template('torque/mom_config.erb'),
	}

	service { 'pbs_mom':
		ensure => running,
		require => File["${torque::params::spool_dir}/mom_priv/config"],
	}

}

