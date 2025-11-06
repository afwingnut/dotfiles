#!/bin/bash
#
# This is my install script.  Once you set up your github dotfiles then change the git clone commands below to use your own.
#
# Test whether a previous run of this script failed due to uninstallable packages
if [ -s "uninstallable_packages" ]; then
  echo "Notification: The file uninstallable_packages exists and is not empty."
  exit 0
fi

sudo sed -i 's/%wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers.d/wheel
sudo xbps-install -Suy
PACKAGES=(alacritty alsa-utils arandr aria2 audacity base-devel bash-completion bat breeze bridge-utils cava chromium clang clang-analyzer clipmenu cloc cmake cmatrix colordiff curl cvs dunst feh ffmpeg ffplay figlet figlet-fonts file-devel firefox flac flameshot fzf gcr-devel gdb gimp go gstreamer1-devel gstreamer-vaapi harfbuzz-devel htop hugo ImageMagick imlib2-devel inkscape instaloader intel-media-driver jq lf libconfig-devel libev-devel libjpeg-turbo-devel libmpc-devel libvirt libX11-devel libXft-devel libXinerama-devel linux-lts linux-lts-headers lolcat-c lsd lxappearance man-db meson mpc mpd mpv mupdf ncmpcpp neovim nerd-fonts NetworkManager newsboat nim ninja nodejs noto-fonts-emoji noto-fonts-ttf noto-fonts-ttf ntfs-3g obs pandoc papirus-folders papirus-icon-theme pass passmenu pcre-devel pcre-devel pdftag pkgconf pkgconf-devel python3-adblock python3-pip qemu qutebrowser ranger readline readline-devel rnnoise rsync sakura screenkey scrot simple-mtpfs slop socklog-void sof-firmware terminus-font time timeshift tmux tty-clock ueberzug ugrep unbound uthash v4l2loopback vde2 virt-manager void-docs-browse vte3 w3m wbg libwebkit2gtk41-devel wkhtmltopdf wlroots-devel xcb-util-image-devel xcb-util-renderutil-devel xdg-desktop-portal-wlr xdotool xorg yt-dlp zathura zathura-pdf-mupdf zig)

# Loop through each package in the list
for PACKAGE in "${PACKAGES[@]}"; do
    # Check if package is available in the repository
        if xbps-query -Rs "$PACKAGE" &> /dev/null; then 
            echo "Installing $PACKAGE"
            sudo xbps-install -y "$PACKAGE"
        else
        echo "Error installing $PACKAGE: not found in repository" >&2
        # If package is not available, add it to the list of uninstallable packages
        echo "$PACKAGE" >> uninstallable_packages
        fi
done

# Test whether all packages installed before proceeding
if [ -s "uninstallable_packages" ]; then
  echo "Notification: The file uninstallable_packages exists and is not empty."
  exit 0
fi
# Safe to proceed
read -p "Are you sure you want to continue? (y/n) "
if [ "$REPLY" = "n" ]; then
  exit 0
fi

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
sudo ln -s /etc/sv/socklog-unix /var/service/
sudo ln -s /etc/sv/nanoklogd /var/service/
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
