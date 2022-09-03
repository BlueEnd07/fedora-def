#!/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

#dnf configration

echo "
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
keepcache=True">>/etc/dnf/dnf.conf
echo "dnf configered "

echo "updating system"
#update system
sudo dnf update -y


#enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#enabling flatpack 
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Install Media Codecs
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y

#Install NVIDIA Drivers:
sudo dnf install akmod-nvidia -y # rhel/centos users can use kmod-nvidia instead 
sudo dnf install xorg-x11-drv-nvidia-cuda -y #optional for cuda/nvdec/nvenc support


#install app

sudo dnf install blender vlc gnome-tweak-tool chrome-gnome-shell gnome-extensions-app kdeconnectd steam -y
flatpak install flathub net.lutris.Lutris -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.brave.Browser -y

#Better Fonts:
sudo dnf copr enable dawid/better_fonts -y
sudo dnf install fontconfig-font-replacements -y
sudo dnf install fontconfig-enhanced-defaults -y
