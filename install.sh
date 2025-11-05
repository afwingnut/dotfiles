#
# This is my install script.  Once you set up your github dotfiles then change the git clone commands below to use your own.
#
sudo sed -i 's/%wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers.d/wheel
sudo xbps-install -Suy
PACKAGES=(xorg base-devel libX11-devel libXft-devel libXinerama-devel chromium ffmpeg ntfs-3g ugrep nerd-fonts noto-fonts-emoji noto-fonts-ttf feh lsd webkit2gtk-devel gcr-devel gstreamer1-devel lxappearance vim neovim clipmenu mpv mpd alsa-utils ncmpcpp cava newsboat zathura mupdf ranger ueberzug qutebrowser sakura w3m alacritty nodejs gimp bash-completion linux-lts yt-dlp aria2 obs neofetch scrot flameshot qemu virt-manager libvirt vte3 vde2 bridge-utils cmake ninja meson curl time screenkey ImageMagick NetworkManager arandr bat breeze clang-analyzer clang cmatrix lolcat-c figlet colordiff timeshift emacs ffplay flac fzf gdb git go zig gstreamer-vaapi harfbuzz-devel htop hugo imlib2-devel inkscape instaloader jq intel-media-driver kdenlive libev-devel libjpeg-turbo-devel libmpc-devel linux-lts-headers man-db mpc pandoc papirus-folders papirus-icon-theme pcre-devel pdftag pkgconf-devel python3-adblock python3-pip rnnoise rsync simple-mtpfs slop stow tcc terminus-font texlive texlive-core tty-clock v4l2loopback void-docs-browse wireshark-qt wireshark wlroots-devel xdg-desktop-portal-wlr xdotool zathura-pdf-mupdf wbg tmux xcb-util-renderutil-devel xcb-util-image-devel pkgconf uthash pcre-devel libconfig-devel lf firefox cloc nim figlet-fonts dunst noto-fonts-ttf passmenu pass wkhtmltopdf cvs audacity unbound readline-devel readline file-devel socklog-void)
# Loop through each package in the list
for PACKAGE in "${PACKAGES[@]}"; do
    # Check if package is available in the repository
    if xbps-query -Rn "$PACKAGE" &> /dev/null; then
        echo "Installing $PACKAGE"
        xbps-install -y "$PACKAGE"
    else
        echo "Error installing $PACKAGE: not found in repository" >&2
        # If package is not available, add it to the list of uninstallable packages
        echo "$PACKAGE" >> uninstallable_packages
    fi
done

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
