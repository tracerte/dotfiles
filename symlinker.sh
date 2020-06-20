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
# - ~/.wallpaper


# Symlinks files in the configuration directories under /usr/ namely:
# - /usr/local/etc/pkg/repos/FreeBSD.conf
# - /usr/local/etc/doas.conf

# This script performs both actions, but the symlinking into /usr/ requires root.

if [ $# -ne 2 ]
then
	echo "Usage: $0 <directory_type> <config>"
	echo "Where <directory_type> is 'usr' or 'home'"
	echo "Where <config_dir> is the base directory of this repo"
	echo "Example: $0 usr ~/dotfiles"
	exit 1
fi

DIRTYPE=$(echo "$1" | tr '[:upper:]' '[:lower:]')


CONFIGDIR=$2

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
	ln -s "${CONFIGDIR}/home/user/bashrc" ~/.bashrc
	ee $? "Unable to symlink bashrc"
	ln -s "${CONFIGDIR}/home/user/aliases" ~/.aliases
	ee $? "Unable to symlink aliases"
	ln -s "${CONFIGDIR}/home/user/xinitrc" ~/.xinitrc
	ee $? "Unable to symlink xinitrc"
	ln -s "${CONFIGDIR}/home/user/conkyrc" ~/.conkyrc
	ee $? "Unable to symlink conkyrc"
	ln -s "${CONFIGDIR}/home/user/Xdefaults" ~/.Xdefaults
	ee $? "Unable to symlink Xdefaults"
	if [ -f ~/.login_conf ]
	then
		echo "login_conf already exists backing it up first"
		mv ~/.login_conf ~/.login_conf_bk
		ee $? "Unable to backup login_conf"
	fi
	ln -s "${CONFIGDIR}/home/user/login_conf" ~/.login_conf
	ee $? "Unable to symlink login_conf"
	ln -s "${CONFIGDIR}/home/user/wallpaper" ~/.wallpaper
	ee $? "Unable to symlink wallpaper"
	echo "Creating the ~/.config/i3 directories"
	mkdir -p ~/.config/i3
	ee $? "Unable to create the i3 config directory structure."
	ln -s "${CONFIGDIR}/home/user/config/i3/config" ~/.config/i3/config
	ee $? "Unable to symlink i3's config"
	ln -s "${CONFIGDIR}/home/user/config/i3/conky-i3bar.sh" ~/.config/i3/conky-i3bar.sh
	ee $? "Unable to symlink conky-i3bar.sh"
	echo "Making conky-i3bar.sh executable"
	chmod +x "${CONFIGDIR}/home/user/config/i3/conky-i3bar.sh" 
elif  [ "${DIRTYPE}" = "usr" ]
then
	echo "Installing configuration files into the usr directory. If this fails it may be because you are not running as root"
	echo "Changing ownership of repo usr directory to root:wheel"
	chown -R root:wheel "${CONFIGDIR}/usr"
	ee $? "Unable to chown the config directory"
	echo "Symlinking configration files into the usr directory"
	ln -s "${CONFIGDIR}/usr/local/etc/doas.conf" /usr/local/etc/doas.conf
	ee $? "Unable to symlink doas.conf"
	echo "Creating folder for pkg repo configuration"
	mkdir -p /usr/local/etc/pkg/repos
	ee $? "Unable to create pkg config file directory structure"
	ln -s "${CONFIGDIR}/usr/local/etc/pkg/repos/FreeBSD.conf" /usr/local/etc/pkg/repos/FreeBSD.conf
	ee $? "Unable to symlink FreeBSD.conf"
else
	ee 1 "Error: invalid directory type specified. Are you sure that ${DIRTYPE} is correct?"
fi