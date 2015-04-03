
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

node /\w*djangoagent\d*$/ {
  include "${operatingsystem}setup"
  include git
  include ssh
  include user
  include nginx
  include django
  include uwsgi

  user::create {'jenkins':
    password   => '$1$963viJj/$VUiSdG/Sjsj4bsQD1uXTX0',
    groups     => 'www-data',
    sshkeytype => 'ssh-rsa',
    sshkey     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMO9a66fvqDHWERw8jjk6Ls8KBM8zDQVI7fbFlt7xPIH+pjPlR0QxZlS8a108dW7WsDBxwd3qycvENfeED7AY4DmhW23UpnlPEnQ4O/0+lRo0rfymVvaE5F+PvooYi+z0F7XAFnBSwwhYhyUvf6KqATmV4ALM+NU4PAOa5fUJskAIzIQuVfnIzMyGSruOnLCvnmw/qZDjhYM6abSvckUmIrYPwN6rYnO8L4t4pQ4dFZVtwLEhHBCPk3VLcPd0Z+TTAn+jzbi58+0iTlKh7/svTvawG9KAI4pWfiHQueWPiZ1HXPmH7QRi1MRaQjeKg9cPFMQtZUjQSUB8tVVzE/f/V',
    #sshkey     => '' #ssh public key without type and user indicators  
}

  file {'/opt':
    ensure => directory,
  }~>
  #clone django git code into the server
  git::clone {'djangoDI':
    repo    => 'https://github.com/pmmu/djangoCI.git',
    path    => '/opt',
    dir     => 'app',
  }~>
  file {'/opt/app':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0774,
    recurse => true,
    ignore  => '*.sock',
  }
  
  nginx::siteconfig {'django_nginx.conf':
    source => 'puppet:///modules/nginx/django_nginx.conf',
    owner  => 'www-data',
    group  => 'www-data'
  }
  uwsgi::siteconfig{'django_uwsgi.ini':
    source => 'puppet:///modules/uwsgi/django_uwsgi.ini',
    owner  => 'www-data',
    group  => 'www-data',
  }
}
