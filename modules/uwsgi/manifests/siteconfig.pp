define uwsgi::siteconfig($source,$owner,$group){
  file {"/etc/uwsgi/vassals/$name":
    ensure  => present,
    source  => $source,
    owner   => $owner,
    group   => $group,
    mode    => 664,
    require => Class['uwsgi'],
    notify  => Class["uwsgi::service"],
  }
  file {'/var/log/uwsgi':
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => 664,
  }
  concat {"/etc/rc.local":
    #ensure => present,
    mode    => 755, 
  } 
  concat::fragment {'00_rc.local_header':
    target  => '/etc/rc.local',
    content => "!/bin/sh -e \n# This file is managed by Puppet. \n\n",
    order   => '01',
  }
  concat::fragment {'02_rc.local_custom':
    target => '/etc/rc.local',
    source => 'puppet:///modules/uwsgi/run_uwsgi.sh',
    order  => '02',
  }
  concat::fragment {'99_rc.local_footer':
    target  => '/etc/rc.local',
    content => "exit 0\n",
    order   => '99',
  }
}
