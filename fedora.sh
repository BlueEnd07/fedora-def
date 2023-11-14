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

#Battery life
sudo dnf install tlp tlp-rdw
sudo systemctl mask power-profiles-daemon
sudo dnf install powertop
sudo powertop --auto-tune

#Install Media Codecs
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y

#Install NVIDIA Drivers:
sudo dnf install akmod-nvidia -y # rhel/centos users can use kmod-nvidia instead 
sudo dnf install xorg-x11-drv-nvidia-cuda -y #optional for cuda/nvdec/nvenc support

sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video -y
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y
sudo dnf install ffmpeg ffmpeg-libs libva libva-utils

#OpenH264 for Firefox
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264

#update flatpack
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
#install app
sudo dnf install blender vlc gnome-tweak-tool chrome-gnome-shell gnome-extensions-app kdeconnectd steam -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.brave.Browser -y
flatpak install flathub com.heroicgameslauncher.hgl -y
flatpak install flathub com.discordapp.Discord -y


#Speed Boost
sudo dnf install grub-customizer -y

#gnome Extenstions
#for Gsconnect
sudo dnf install nautilus-python



 
