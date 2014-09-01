#Puppet Configuration Code for Puppet Agents running the RoboRavers app and API
This repository contains all of the puppet configuration code that would live on a puppetmaster server running CentOS6.5.  The master server currently running this is https://107.170.235.244/

##Standup new Debian Wheezy 7.0 Puppet Agent
Create a new server, naming it mujinraveagent{#}, where {#} is a number greater than 1


###Install some basic needs

	apt-get -y install vim



###Set Hosts

	vim /etc/hosts

add row for master ip address, pointing to puppet puppetmaster

	107.170.235.244 puppet puppetmaster #Puppet master DNS aliases and Puppet master FQDN



###Install Puppet Agent from the Master

	curl -k https://puppetmaster:8140/packages/current/install.bash | bash

Goto PE console on master:

	https://107.170.235.244/

and approve the node request (top right)

to test (it will happen automatically in 30 minutes) run...

	puppet agent --test
	
initial setup runs through full make install of collada-dom and open-rave, taking longer than subsequent runs


###Daemonize Puppet Agent and Restart

Run puppet agent to daemonize puppet 
  
	puppet agent
  

Restart the agent server to automatically start Uwsgi and the app.


###Navigate to the site

	http://<serverip>:8000/robot for the webapp
	
	http://<serverip>:8000/robots for the browsable API



###Deleting an agent

If you ever have to remove an agent, remove from puppet ee console, then run this on the master.

	puppet cert clean mujinraveagent{#}
