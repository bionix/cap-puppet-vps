class sudo {
  package { sudo:
    ensure => present,
  }

  file { "/etc/sudoers.d/":
    ensure => directory,
    source => "puppet:///modules/sudo/etc/sudoers.d/",
    recurse => true,
    purge => true,
    mode => 0440,
    owner => "root",
    group => "root"
  }

  file { "/etc/sudoers":
    owner => "root",
    group => "root",
    mode => 0440,
    source => "puppet:///modules/sudo/etc/sudoers",
    require => Package["sudo"],
  }


	define rule($entity, $command, $as_user, $password_required = true, $comment = false, $order = 15) {
		$the_comment = $comment ? {
			false   => $name,
			default => $comment
		}
    $sudoerfile = inline_template("<%=name.gsub('.','_') %>")

		file { "/etc/sudoers.d/${sudoerfile}":
			mode => 440,
			owner => "root",
			group => "root",
			content => template("sudo/sudo.erb"),
		}
	}
}
