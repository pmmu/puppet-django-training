##Standup new Debian Wheezy 7.0 Puppet Agent
===========================================================
Create a new server, naming it mujinraveagent{#}, where {#} is a number greater than 1


Install some basic needs
===========================================================
	yum -y install vim
OR
	apt-get -y install vim



Set Hosts
===========================================================
	vim /etc/hosts

#add row for master ip address, pointing to puppet puppetmaster
	107.170.235.244 puppet puppetmaster #Puppet master DNS aliases and Puppet master FQDN



Install Puppet Agent from the Master
===========================================================
	curl -k https://puppetmaster:8140/packages/current/install.bash | bash

Goto PE console on master:
https://107.170.235.244/
and approve the node request (top right)

to test (it will happen automatically in 30 minutes) run...
	puppet agent --test
	
initial setup runs through full make install of collada-dom and open-rave, taking longer than subsequent runs


Daemonize Puppet Agent and Restart
===========================================================
then run puppet agent to daemonize puppet 
  puppet agent
  

Restart the agent to automatically start Uwsgi and the app.


Navigate to the site
===========================================================
http://<serverip>:8000/robot for the webapp
http://<serverip>:8000/robots for the browsable API


NOTE:
If the site throws a permissions error, which I saw once during testing, you may need to run this on the agent:
  chown www-data:www-data -R /opt/mujin


Deleting an agent
===========================================================
If you ever have to remove an agent, remove from puppet ee console, then run this on the master.

  puppet cert clean mujinraveagent{#}
