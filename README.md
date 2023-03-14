# My Personal Dotfiles
Powered by [`Chezmoi`](https://www.chezmoi.io/) and [`Homebrew`](https://brew.sh/).

# Installation

## Requirements
### Linux
Homebrew is managed by chezmoi.
To install build tools required by homebrew, paste at a terminal prompt:
* Debian / Ubuntu
```sh
sudo apt-get install build-essential procps curl file git
```
* Fedora, CentOS, or Red Hat
```sh
sudo yum groupinstall 'Development Tools'
sudo yum install procps-ng curl file git
```
* OpenSUSE
```sh
sudo zypper install patterns-devel-base-devel_basis curl file git
```
### macOS
For macOS the easiest way is to install homebrew first and then install chemzoi with `brew install chezmoi`. The homebrew dependencies are installed by itselve.
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install the dotfiles with chezmoi
The following environment variables can be set to configure chezmoi when applying changed:
* `DOTFILES_MINIMAL` Set to `1` if you want to install the minimal version

One-Line-Installer:
```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Deathlord89
```
or if `chezmoi` is already installed:
```sh
chezmoi init Deathlord89 --apply
```