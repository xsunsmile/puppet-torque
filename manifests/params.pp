
class torque::params {

	$torque_version = extlookup('torque_version')
	$install_dist = extlookup('torque_install_dist')
	$install_src = extlookup('torque_install_src')
	$spool_dir = extlookup('torque_spool_dir') ? {
		'' => "/var/spool/torque",
		default => extlookup('torque_spool_dir')
	}

	$torque_admin = extlookup('torque_admin')
	$compile_args_extra = extlookup('torque_complie_args_extra')
	$torque_master = extlookup('torque_master_name')

	$torque_initd = "${install_src}/torque/contrib/init.d"
	$compile_args = "--prefix=${install_dist} --enable-high-availability --with-default-server=${torque_master} --enable-drmaa ${compile_args_extra}"

}
