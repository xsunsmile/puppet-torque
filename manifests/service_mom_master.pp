
class torque::service_mom_master inherits torque::service_mom {

	include torque::install

	File["${torque::params::spool_dir}/mom_priv/config"] {
		require +> [
			File['/etc/init.d/pbs_mom'],
			Exec['install-torque'],
		],
	}

}

