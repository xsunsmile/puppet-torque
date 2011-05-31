
class torque {
	include torque::params
	if $hostname == $torque::params::torque_master {
		include torque::compile
		include torque::install
	else {
		include torque::pkg_install
	}
	include torque::service
	# add yours:
	# include torque::extra
}
