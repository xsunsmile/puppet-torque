class torque::compile {

	package { "build-essential": ensure => installed }

	file { "${torque::params::install_src}":
		ensure => directory,
		owner => root,
		group => root,
		mode => 0777,
	}

	file { "${torque::params::install_src}/fetch.sh":
		ensure => present,
		owner => root,
		group => root,
		mode => 0755,
		source => "puppet:///torque/fetch.sh",
		require => File["${torque::params::install_src}"],
	}

	exec { "download":
		cwd => "${torque::params::install_src}",
		command => "/bin/sh fetch.sh",
		onlyif => "test ! -e ${torque::params::install_src}/torque",
		require => File["${torque::params::install_src}/fetch.sh"],
	}

	file { "${torque::params::install_src}/torque":
		ensure => directory,
		mode => 0777,
		require => Exec['download'],
	}

	exec { "configure-torque":
		path => "/bin:/usr/bin:/usr/sbin",
		cwd => "${torque::params::install_src}/torque",
		command => "nice -19 sh configure ${torque::params::compile_args}",
		require => [ File["${torque::params::install_src}/torque"], Package['build-essential'] ],
		onlyif => "test ! -e ${torque::params::install_src}/config.log",
	}

	exec { "build-torque":
		path => "/bin:/usr/bin:/usr/sbin",
		cwd => "${torque::params::install_src}/torque",
		command => "nice -19 make",
		require => Exec['configure-torque'],
		timeout => 0,
		onlyif => "test ! -e ${torque::params::spool_dir}"
	}

	fpm::package{ 'torque':
		source_type => 'dir',
		package_type => 'deb',
		package_src => "${torque::params::install_src}/torque",
		package_version => '2.5.5',
		build_dirname => '/tmp/build',
	}

}
