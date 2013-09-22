# cron task for package manager clean ups
case $::operatingsystem {
  RedHat,CentOS,Fedora: {
    cron { 'yum_clean':
      ensure    => present,
      command   => 'yum clean all',
      user      => 'root',
      hour      => '3',
      minute    => '47',
    }
  }
  Debian,Ubuntu:        {
    cron { 'aptget_clean':
      ensure    => present,
      command   => 'apt-get clean',
      user      => 'root',
      hour      => '3',
      minute    => '47',
    }
  }
  default:              { notice "Unsupported OS ${::operatingsystem}" }
}

# I need mosh everywhere!!!
package { 'mosh':
  ensure => latest,
}

