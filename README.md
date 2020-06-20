# FreeBSD Workstation Configuration Files

This repository contains my configuration files for my FreeBSD workstations. In order to use this repo, ensure that you have a fresh install of FreeBSD, with a regular user in the `wheel` group. 

Obviously, git should be installed and configured on the workstation to pull down the repository.

```sh
# pkg install git
```

Simple configuration:

```sh
$ git config --global user.name "Matthew B. Reisch"
$ git config --global user.email "matt@example.com" 
```

## Installation

Run `setup.sh` with the following parameters:

- `config`: Installs (symlinks) config files
- `admin`: Installs admin related packages and makes additional inline configurations.
- `desktop`: Installs desktop related packages and makes additional inline configurations.
- `bash`: Installs bash related packages and changes the calling user's default shell to bash
- `intel`: Installs Intel graphics card drivers and xorg and then makes inline configurations
- `boot`: Changes the boot delay

