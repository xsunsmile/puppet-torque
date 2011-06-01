
class torque::service_mom_node inherits torque::service_mom {

	include torque::pkg_install

	file { "${torque::params::install_dist}/sbin/pbs_mom":
		ensure => absent,
	}

	File["${torque::params::spool_dir}/mom_priv/config"] {
		require +> [
			Exec['install-torque-package'],
			File["${torque::params::install_dist}/sbin/pbs_mom"],
		],
	}

}
