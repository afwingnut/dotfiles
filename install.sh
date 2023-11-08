#
# This is my install script.  Once you set up your github dotfiles then change the git clone commands below to use your own.
#




cd /tmp/
git clone https://github.com/pijulius/picom.git
cd picom/
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install
cd
git clone https://github.com/afwingnut/dotfiles
cd ~/dotfiles/
cp -r .config/ .fonts/ .icons/ .local/ .themes/ .bashrc .xinitrc .tmux.conf .bash_profile ~/
cd suckless/dwm/ && make && sudo make install
cd ../dmenu/ && make && sudo make install
cd ../st/ && make && sudo make install
cd ../slstatus/ && make && sudo make install
cd ../slock/ && make && sudo make install
cd ../farbfeld/ && make && sudo make install
cd ../sent/ && make && sudo make install
cd ../surf/ && make && sudo make install
cd
git clone https://gitlab.com/dwt1/wallpapers.git
cd /tmp/
git clone https://github.com/garabik/grc.git
cd grc/
sudo ./install.sh
cd
sudo cp /etc/profile.d/grc.sh /etc/
sudo xbps-remove -Oy && sudo xbps-remove -oy
sudo xbps-reconfigure -f linux-lts
sudo xbps-reconfigure -fa
fc-cache -fv
sudo sv down dhcpcd
sudo ln -s /etc/sv/NetworkManager /var/service/
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/libvirtd /var/service/
sudo ln -s /etc/sv/virtlogd /var/service/
sudo rm /var/service/agetty-tty3
sudo rm /var/service/agetty-tty4
sudo rm /var/service/agetty-tty5
sudo rm /var/service/agetty-tty6
sudo rm /var/service/wpa_supplicant
sudo rm /var/service/dhcpcd
sudo sed -i 's/GRUB_TIMEOUUT=5/GRUB_TIMEOUUT=0/' /etc/default/grub
# The line below automatically logs in user "sh" in tty1 so use caution before uncommenting.
#sudo sed -i 's/GETTY_ARGS="--noclear"/GETTY_ARGS="--noclear --autologin sh"/' /etc/runit/runsvdir/current/agetty-tty1/conf
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
