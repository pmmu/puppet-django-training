#Puppet Configuration Code for Puppet Agents running Django
This repository contains all of the puppet configuration code that would live on a puppetmaster server running CentOS for creating servers to run the test django app (found here: https://github.com/pmmu/djangoCI).  

##Standup new Debian Wheezy 7.0 Puppet Agent
Create a new server, naming it djangoagent{#}, where {#} is a number greater than 1


###Install some basic needs

	apt-get -y install vim



###Set Hosts

	vim /etc/hosts

add row for master ip address, pointing to puppet puppetmaster

	<masterip> puppet puppetmaster #Puppet master DNS aliases and Puppet master FQDN



###Install Puppet Agent from the Master

	curl -k https://puppetmaster:8140/packages/current/install.bash | bash

Goto PE console on master:

	https://<masterip>:3000

and approve the node request (top right)

to test run...

	puppet agent --test
	
initial setup runs through full make install of django, taking longer than subsequent runs


###Daemonize Puppet Agent and Restart

Run puppet agent to daemonize puppet 
  
	puppet agent
  

Restart the agent server to automatically start Uwsgi and the app.


###Navigate to the site

	http://<serverip>:8000/robot for the webapp



###Deleting an agent

If you ever have to remove an agent, remove from puppet ee console, then run this on the master.

	puppet cert clean djangoagent{#}
