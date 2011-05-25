
class torque::params {

	$install_dist = extlookup('torque_install_dist')
	$torque_admin = extlookup('torque_admin')
	$compile_args_extra = extlookup('torque_complie_args_extra')
	$torque_master = extlookup('torque_master_name')

	$torque_initd = "${install_dist}/torque/contrib/init.d"
	$complie_args = "--prefix=${install_dist} --enable-drmaa ${compile_args_extra}"

}
