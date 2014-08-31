# rc.local
#
# This script is executed at the end of each multiuser runlevel.
#

test -e /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
blkid | grep -q /dev/vda && test ! -e /boot/grub/device.map && echo "(hd0) /dev/vda" > /boot/grub/device.map

/usr/local/bin/uwsgi --emperor /etc/uwsgi/vassals --uid www-data --gid www-data

