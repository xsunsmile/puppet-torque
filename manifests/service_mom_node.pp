
class torque::service_mom_node inherits torque::service_mom {

	include torque::pkg_install

	File["${torque::params::spool_dir}/mom_priv/config"] {
		require +> Exec['install-torque-package'],
	}

}
