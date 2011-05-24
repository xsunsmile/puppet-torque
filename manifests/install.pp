
class torque::install {

	file { '/var/spool/torque/checkpoint':
		ensure => directory,
		mode => 0755,
		owner => root,
		group => root,
		require => Exec['install-torque'],
	}

}
