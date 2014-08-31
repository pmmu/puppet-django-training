# class uwsgi
# 
# installs uwsgi package
# and sets the config file
#
class uwsgi ($owner='www-data',$group='www-data') {
  include uwsgi::service
  uwsgi::install{'install-uwsgi':
    owner => $owner,
    group => $group,
  }
}

define uwsgi::install($owner,$group) {
  package {'uwsgi':
    ensure   => present,
    provider => pip,
  }
  #exec {"install uwsgi":
  #  command => '/usr/bin/pip install uwsgi',
  #}
  file {"/etc/uwsgi":
    ensure => directory,
    owner => $owner,
    group => $group,
  }
  file {"/etc/uwsgi/vassals":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
    require => File['/etc/uwsgi'],
  }
}

class uwsgi::service{
  #service {'uwsgi':
  #  ensure  => running,
  #  require => Package['uwsgi'],
  #}
}

Class['uwsgi'] -> Class["uwsgi::service"]
