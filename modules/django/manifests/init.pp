# class django
#
# to install django and essentials
# todo:test with 2.4.1 djangorestframework. 
#
class django {
    package {
        "django"              : ensure => present,  provider => pip;
        "djangorestframework" : ensure => '2.3.14', provider => pip;
        "markdown"            : ensure => present,  provider => pip;
    }
    #exec {"install django":
    #	command => '/usr/bin/pip:/usr/local/bin/pip install django',
    #}
}
