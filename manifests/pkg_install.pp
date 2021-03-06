
class torque::pkg_install {

	$version = $torque::params::torque_version
	$arch = $architecture ? {
		/x86_64|amd64/ => 'amd64',
		default => 'i386',
	}

	file { "/tmp/torque-${version}_${arch}.deb":
		ensure => present,
		source => "puppet:///torque/torque-${version}_${arch}.deb",
	}

	file { "/tmp/torque_dev-${version}_${arch}.deb":
		ensure => present,
		source => "puppet:///torque/torque_dev-${version}_${arch}.deb",
	}

	file { "/tmp/torque_doc-${version}_${arch}.deb":
		ensure => present,
		source => "puppet:///torque/torque_doc-${version}_${arch}.deb",
	}

	file { "/tmp/torque_initd-${version}_${arch}.deb":
		ensure => present,
		source => "puppet:///torque/torque_initd-${version}_${arch}.deb",
	}

	exec { 'install-torque-package':
		path => "/usr/bin",
		user => "root",
		command => "sudo dpkg -i /tmp/torque*-${version}_${arch}.deb",
		require => [
			File["/tmp/torque-${version}_${arch}.deb"],
			File["/tmp/torque_dev-${version}_${arch}.deb"],
			File["/tmp/torque_doc-${version}_${arch}.deb"],
			File["/tmp/torque_initd-${version}_${arch}.deb"],
		],
		onlyif => "test ! -e ${torque::params::install_dist}/sbin/pbs_mom",
	}

	exec { "setuid_pbs_iff":
		path => "/bin",
		command => "chmod u+s ${torque::params::install_dist}/sbin/pbs_iff",
		require => Exec['install-torque-package'],
	}

}
