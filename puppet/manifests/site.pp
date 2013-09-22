# site.pp - central node configuration
#
# Default path, tailored towards lsb - should be ok for all linux dists
Exec {
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/nagios/plugins"
}
# load common settings, modules and additional classes
import "common.pp"
import "base.pp"
include stdlib
include sudo

case $::operatingsystem {
  Debian,Ubuntu:          {
    class { 'apt': }
    apt::source { 'grml':
      location   => 'http://deb.grml.org',
      release    => 'grml-stable',
      repos      => 'main',
      key        => 'ECDEA787',
      key_server => 'subkeys.pgp.net',
    }
    class { 'apt::backports':
      location => 'http://http.debian.net/debian/'
    }
  }
  Redhat,CentOS,Fedora:   { class { 'yum':
    extrarepo => [ 'epel' , 'puppetlabs' ] }
  }
  Default:                { notice "Do nothing" }
}
# Load nodes definitions
import 'nodes.pp'
