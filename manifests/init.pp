
class torque {

	include torque::params
	$mongodb_host = extlookup('mongodb_host')
	# $master_arch = mongolookup("mongodb://${mongodb_host}:27017/inters_hosts/hosts/${torque::params::torque_master}/arch")

	if $hostname == $torque::params::torque_master {
		include torque::compile
		include torque::install
	} else {
		include torque::pkg_install
	}
	include torque::service

}
