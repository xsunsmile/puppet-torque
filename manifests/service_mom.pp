class torque::service_mom {

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
		require => File["${torque::params::spool_dir}/mom_priv/config"],
	}

}

class torque::service_mom_master inherits torque::service_mom {

	include torque::install

	File["${torque::params::spool_dir}/mom_priv/config"] {
		require +> File['/etc/init.d/pbs_mom'],
	}

}

class torque::service_mom_node inherits torque::service_mom {

	include torque::pkg_install

	File["${torque::params::spool_dir}/mom_priv/config"] {
		require +> Exec['install-torque-package'],
	}

}
