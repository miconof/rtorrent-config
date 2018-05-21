#!/bin/bash
set -e

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
sudo cp rtorrent.service /etc/systemd/system || fail "Failed to copy the rtorrrent init script. Does it exist in the current directory?"
sudo systemctl start rtorrent
sudo systemctl enable rtorrent || fail "Failed to add rtorrrent system startup links. Is the init script already configured?"
echo "DONE"

echo "The following alias might be useful, setting it in bashrc."
echo "alias rtorrent='dtach -A /home/pi/.rtsession/rtorrent.dtach -e Q /usr/bin/rtorrent'"
echo "alias rtorrent='dtach -A /home/pi/.rtsession/rtorrent.dtach -e Q /usr/bin/rtorrent'" >> ~/.bashrc

echo "rtorrent has been installed."
exit 0
