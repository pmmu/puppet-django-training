
## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => 'puppetmaster',
  path   => false,
}

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}

node /\w*puppetmaster\d*$/ {
  include "${operatingsystem}setup"
  include ssh
}

node /\w*raveagent\d*$/ {
  include "${operatingsystem}setup"
  include git
  include ssh
  include user
  include nginx
  include django
  include uwsgi
  include openrave

  user::create {'jenkins':
    password   => '$1$963viJj/$VUiSdG/Sjsj4bsQD1uXTX0',
    groups     => 'www-data',
    sshkeytype => 'ssh-rsa',
    sshkey     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAymAbZVK7I9ScUqIZqvyj3E37O+Vxd6CL1bRxwy6y0Knjf2OS4a0M9ZxlqTSqp3p00+8iVTsFoytQf3OVHpIJzCfqgqHx4voINPTlMzR3jwPAWnw9ws2nhL6QB1sE6JmBrFRXcmDeozBEm5hLrfWLIadtYLjNoYEU/oeKRgYlGVv7cIF1vhzhxxN2NEL6zUnXw/8tRBDcfcibwvBd8a73mXHov/PcpiZWB3bB3OfoK1khtvQra9QRJaYN4sr2o4vsBK70KVCYGKqL4My+jZxmjJnIolFaVu5G4/94ISZOWgDZ8aDJuST+c2u9ZjkfVSON9jIYOySiudsR7w7OIhQBcQ==',
    #sshkey     => '' #ssh public key without type and user indicators  
}

  file {'/opt':
    ensure => directory,
  }~>
  #clone django git code into the server
  git::clone {'mujin_rave':
    repo    => 'https://github.com/cinvoke/mujin.git',
    path    => '/opt',
    dir     => 'mujin',
  }~>
  file {'/opt/mujin':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0774,
    recurse => true,
  }
  
  nginx::siteconfig {'mujin_nginx.conf':
    source => 'puppet:///modules/nginx/mujin_nginx.conf',
    owner  => 'www-data',
    group  => 'www-data'
  }
  uwsgi::siteconfig{'mujin_uwsgi.ini':
    source => 'puppet:///modules/uwsgi/mujin_uwsgi.ini',
    owner  => 'www-data',
    group  => 'www-data',
  }
}
