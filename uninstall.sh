#!/bin/bash
########################################################
# rTorrent Uninstaller 2012 November 2
########################################################
# Author: daymun (http://github.com/daymun)
# Modified by: miconof (http://github.com/miconof)
# GitHub repository: http://github.com/miconof/rtorrent-webui-installer
# Description: Reverses any changes to the system made by install.sh.
########################################################

function fail {
	echo "$1" 1>&2
	echo -n "Continue anyway? [Y/n] "
	read continue
	if [ "$continue" = "n" ]; then
		exit 1
	fi
}

# Stop the rTorrent INIT script
echo "Stopping the rTorrent INIT script..."
sudo /etc/init.d/rtorrent stop || fail "Failed to stop the rTorrent INIT script."
echo "DONE"

# Remove the rTorrent INIT script
echo "Removing the rTorrent INIT script..."
sudo update-rc.d -f rtorrent remove || fail "Failed to remove rTorrent system startup links."
sudo rm /etc/init.d/rtorrent || fail "Failed to remove the rTorrent INIT script."
echo "DONE"

# Ask the user if all packages should be removed
echo -n "THE FOLLOWING PACKAGES WILL NOW BE REMOVED: rtorrent. Continue removing said packages? [y/N] "
read verify
if [ "$verify" = "y" ]; then # User said yes, remove packages
	sudo apt-get purge rtorrent || fail "Failed to remove rTorrent and required packages."
        sudo apt-get autoremove
else # User did not say yes
	echo "No packages were removed."
fi
echo "Uninstallation has completed successfully."
exit 0
