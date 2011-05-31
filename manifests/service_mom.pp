class torque::service_mom {

	file { "${torque::params::spool_dir}/mom_priv/config":
		ensure => present,
		owner => root,
		group => root,
		mode => 744,
		content => template('torque/mom_config.erb'),
		require => Exec['install-torque'],
	}

	if $hostname == $torque::params::torque_master {
		include torque::install
		File["${torque::params::spool_dir}/mom_priv/config"] {
			require +> File['/etc/init.d/pbs_mom'],
		}
	} else {
		include torque::pkg_install
		File["${torque::params::spool_dir}/mom_priv/config"] {
			require +> Exec['install-torque-package'],
		}
	}

	service { 'pbs_mom':
		ensure => running,
		require => File["${torque::params::spool_dir}/mom_priv/config"],
	}

}

