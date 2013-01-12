#!/bin/bash
set -e
########################################################
# rTorrent WebUI Installer 2012 November 24
########################################################
# Author: daymun (http://github.com/daymun)
# Coauthor: JMV290 (http://github.com/JMV290)
# Modified by: miconof (http://github.com/miconof)
# GitHub repository: http://github.com/miconof/rtorrent-webui-installer
# Description: Automatically downloads and configures rTorrent and a WebUI; wTorrent and ruTorrent are currently supported.
########################################################
# This script and the configuration files are a combination of the information posted on these guides:
# http://www.wtorrent-project.org/trac/wiki/DebianInstall/
# http://robert.penz.name/82/howto-install-rtorrent-and-wtorrent-within-an-ubuntu-hardy-ve/
# http://flipsidereality.com/blog/linux/rtorrent-with-wtorrent-on-debian-etch-complete-howto/
########################################################

function fail {
	echo "$1" 1>&2
	echo "If you are trying to re-install, run uninstall.sh first."
	exit 1
}

USER=pi

if [ "$(whoami)" = "$USER" ]; then
    echo "Configuring rtorrent for user $USER"
else
    echo "User $USER not in use"
    exit 1
fi

# Install rtorrent and required packages
echo "Installing rtorrent and required packages..."
sudo apt-get -y install rtorrent dtach
echo "DONE"

# Copy the rtorrent configuration file and create folders for downloading torrents to
echo "Copying rtorrent configuration file and creating folders..."
cp rtorrent.rc /home/$USER/.rtorrent.rc || fail "Failed to copy .rtorrent.rc. Does it exist in the current directory?"
mkdir -p /home/$USER/.rtsession/ || fail "Failed to create /home/$USER/.rtsession and sub directories."
echo "DONE"

# Copy and start the rtorrent init script
echo "Copying rtorrent init script..."
sudo cp rtorrent /etc/init.d/rtorrent || fail "Failed to copy the rtorrrent init script. Does it exist in the current directory?"
sudo /etc/init.d/rtorrent start
sudo update-rc.d rtorrent defaults || fail "Failed to add rtorrrent system startup links. Is the init script already configured?"
echo "DONE"

echo "The following alias might be useful, setting it in bashrc."
echo "alias rtorrent='dtach -A /home/pi/.rtsession/rtorrent.dtach /usr/bin/rtorrent'"
echo "alias rtorrent='dtach -A /home/pi/.rtsession/rtorrent.dtach /usr/bin/rtorrent'" >> ~/.bashrc

echo "rtorrent has been installed."
exit 0
