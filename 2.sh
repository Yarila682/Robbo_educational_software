#!/bin/bash
# this script install repitierhost x64 and all copy all setting for Robbo3dmini
user_home=`xdg-user-dir`
user=$SUDO_USER
current_dir=`pwd`
echo $current_dir;

if [ "/$SUDO_USER" != "/root" ]
then
	if [ "/$SUDO_USER" != "/" ]
	then
		user_home=/home/$SUDO_USER
	else
		user="root"
	fi
fi

echo $user_home;

# delete old repitierhost install
# echo "please enter your user password and press enter"
# echo "пожалуйста введите свой пароль и нажмите enter"
sudo rm -rf /opt/RepetierHost
# delete old Slic3r settings
sudo rm -rf $user_home/.Slic3r
# delete old repitierhost settings
sudo rm -rf $user_home/.mono

# add user to dialout group to grant sccess to serial ports
sudo usermod "$user" -aG dialout
sudo usermod root -aG dialout

#debs repitier
sudo apt-get -qqy install mono-complete
sudo apt-get -qqy install freeglut3

cd $current_dir
# Repitierhost and Slic3r setting for Robbo 3D mini then fix settings to current user
# user_home=`xdg-user-dir`
if [ ! -d $user_home/.Slic3r ];
then
tar -xvf repetierhost.dotfiles.mono.tar.gz -C $user_home
echo "extracted repetierhost.dotfiles.mono.tar.gz to $user_home-------------------------------------------------------------------"
tar -xvf repetierhost.dotfiles.slic3r.tar.gz -C $user_home
echo "extracted repetierhost.dotfiles.slic3r.tar.gz to $user_home-------------------------------------------------------------------"
chmod 777 $user_home/.mono
chmod 777 $user_home/.Slic3r
echo "rights on .mono and .Slic3r are 777-------------------------------------------------------------------"


find $user_home/.Slic3r -type f -name '*' -exec sed -i -r 's/robboclub/'$USER'/g' {}\;
find $user_home/.mono -type f -name '*' -exec sed -i -r 's/robboclub/'$USER'/g' {} \;
fi
sudo tar -xvf repetierhost.tar.gz -C /opt

cd /opt/RepetierHost/
./createDesktopIcon.sh

#copy repiterhost shortcut to desktop
name123=repetier-RepetierHost.desktop
# user_desktop=`xdg-user-dir DESKTOP`
user_desktop="$user_home/Desktop"
cp /usr/share/applications/$name123 "$user_desktop"
tar -xvf $current_dir/3D_models.tar.gz -C "$user_desktop"

chmod 777 "$user_desktop/$name123"
#WHY 777?
chmod 777 $user_desktop/3D_models

#cp /opt/RepetierHost/repetier-RepetierHost.desktop ~/Рабочий\ стол/
#cp /opt/RepetierHost/repetier-RepetierHost.desktop ~/Desktop/

#robbo wallpapers
sudo cp $current_dir/linuxmint.jpg /usr/share/backgrounds
sudo cp $current_dir/robbo-wallpapers.png /usr/share/backgrounds
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/robbo-wallpapers.png"
gsettings set org.mate.background picture-filename /usr/share/backgrounds/robbo-wallpapers.png
echo "CONGRATULATIONS!!! FINISHED!!!"
