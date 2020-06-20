#! /bin/sh

# Symlinks files in the home directory of the user namely:
# - ~/.bashrc
# - ~/.aliases
# - ~/.xinitrc
# - ~/.conkyrc
# - ~/.Xdefaults
# - ~/.login_conf
# - ~/.config/i3/config
# - ~/.config/i3/conky-i3bar.sh


# Symlinks files in the configuration directories under /usr/ namely:
# - /usr/local/etc/pkg/repos/FreeBSD.conf
# - /usr/local/etc/doas.conf

# This script performs both actions, but the symlinking into /usr/ requires root.

if [ $# -ne 1 ]
then
	echo "Usage: $0 <directory_type>"
	echo "Where <directory_type> is 'usr' or 'home'"
	echo "Example: $0 usr"
	exit 1
fi

DIRTYPE=$(echo "$1" | tr '[:upper:]' '[:lower:]')


PWD=$(pwd)

ee(){
  if [ "$1" -ne 0 ]
  then
    echo "[ERROR] ${2}"
    exit "$1"
  fi
}

if [ "${DIRTYPE}" = "home" ]
then
	echo "Installing configuration files into the current user's home directory"
	ln -s "${PWD}/home/user/bashrc" ~/.bashrc
	ln -s "${PWD}/home/user/aliases" ~/.aliases
	ln -s "${PWD}/home/user/xinitrc" ~/.xinitrc
	ln -s "${PWD}/home/user/conkyrc" ~/.conkyrc
	ln -s "${PWD}/home/user/Xdefaults" ~/.Xdefaults
	ln -s "${PWD}/home/user/login_conf" ~/.login_conf
	echo "Creating the ~/.config/i3 directories"
	mkdir -p ~/.config/i3
	ln -s "${PWD}/home/user/config/i3/config" ~/.config/i3/config
	ln -s "${PWD}/home/user/config/i3/conky-i3bar.sh" ~/.config/i3/conky-i3bar.sh
	echo "Making conky-i3bar.sh executable"
	chmod +x "${PWD}/home/user/config/i3/conky-i3bar.sh" 

elif  [ "${DIRTYPE}" = "usr" ]
then
	echo "Installing configuration files into the usr directory. If this fails it may be because you are not running as root"
	echo "Changing ownership of repo usr directory to root:wheel"
	chown -R root:wheel "${PWD}/usr"
	echo "Symlinking configration files into the usr directory"
	ln -s "${PWD}/usr/local/etc/doas.conf" /usr/local/etc/doas.conf
	echo "Creating folder for pkg repo configuration"
	mkdir -p /usr/local/etc/pkg/repos
	ln -s "${PWD}/usr/local/etc/pkg/repos/FreeBSD.conf" /usr/local/etc/pkg/repos/FreeBSD.conf
else
	ee 1 "Error: invalid directory type specified. Are you sure that ${DIRTYPE} is correct?"
fi
ee $? "Could not complete symlinking"