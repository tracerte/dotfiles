#! /bin/sh

ee(){
  if [ "$1" -ne 0 ]
  then
    echo "[ERROR] ${2}"
    exit "$1"
  fi
}


if [ $# -ne 1 ]
then
  echo "Usage: $0 <action_type>"
  echo "Where <action_type> is 'config', 'admin', 'desktop', 'bash', 'intelx' or 'boot'"
  echo "Example: $0 config"
  exit 1
fi

PWD=$(pwd)
CALLUSER=$USER

ACTIONTYPE=$(echo "$1" | tr '[:upper:]' '[:lower:]')

if [ "${ACTIONTYPE}" = "config" ]
then
	echo "Symlinking"
	su - root -c "${PWD}/symlinker.sh usr"
	"${PWD}"/symlinker.sh home
elif [ "${ACTIONTYPE}" = "admin" ]
then
	echo "Installing admin packages"
	su - root -c "pkg update -f"
	su - root -c "pkg install < ${PWD}/admin-packages.txt"
elif [ "${ACTIONTYPE}" = "desktop" ]
then
	echo "Installing desktop packages"
	su - root -c "pkg update -f"
	su - root -c "pkg install < ${PWD}/desktop-packages.txt"
	echo "Enabling sound"
	su - root -c "echo snd_hda_load=\"YES\" >> /boot/loader.conf"
elif [ "${ACTIONTYPE}" = "bash" ]
then
	echo "Installing bash packages"
	su - root -c "pkg update -f"
	su - root -c "pkg install < ${PWD}/bash-packages.txt"
	echo "Changing user shell to bash"
	su - root -c "chpass -s /usr/local/bin/bash ${CALLUSER}"
elif [ "${ACTIONTYPE}" = "intel" ]
then
	echo "Installing intel and xorg packages"
	su - root -c "pkg update -f"
	su - root -c "pkg install < ${PWD}/intel-xorg-packages.txt"
	echo "Adding Intel video kernel module to rc.conf"
	su - root -c "sysrc kld_list=\"i915kms\""
	echo "Adding calling user to video group"
	su - root -c "pw groupmod video -m ${CALLUSER}"
	echo "Enabling Kernel Mode Setting (KMS) for vt device"
	su - root -c "echo kern.vty=\"vt\" >> /boot/loader.conf"

elif [ "${ACTIONTYPE}" = "boot" ]
then
	echo "Change boot delay from 10 to 5 seconds"
	su - root -c "echo autoboot_delay=\"5\" >> /boot/loader.conf"
else
	echo "Error, unrecognizable action_type: ${ACTIONTYPE}"
	exit 1
fi
ee $? "Error setting up system"