#!/bin/bash
set -e

sudo echo "Mr. P installation"

read -p 'Install Cura? [yn] ' -r
if [[ $REPLY =~ ^[Yy]$ ]];
then
  INSTALL_CURA=1
fi

read -p 'Install Intellij? [yn] ' -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  INSTALL_INTELLIJ=1
fi

echo 'This script will install the following tools:'
echo '* Unattended Updates'
echo '* git'
echo '* python3'
echo '* docker'
echo '* vim'
echo '* Sublime 3'
echo '* Java (system latest)'
if [[ -n $INSTALL_INTELLIJ ]]; then echo '* IntelliJ Ultimate'; fi
echo '* KeepassXC'
echo '* Meld'
echo '* Filezilla'
echo '* 7zip'
echo '* VLC'
echo '* Chrome'
echo '* Gimp'
echo '* Virtualbox 6'
if [[ -n $INSTALL_CURA ]]; then echo '* CURA'; fi
echo '* zsh + oh-my-zsh'
echo '* Cinnamon + custom theming'
echo '* Some wallpapers'
echo '* Remove spam and ad launcher icons'

read -p 'Proceed install? [yn] ' -r
if [[ $REPLY =~ ^[Nn]$ ]]; then
  exit 0
fi

sudo apt-get update

echo '> Enable unattended upgrades'
sudo apt-get -y install unattended-upgrades

echo '> Install git'
sudo apt-get -y install git git-lfs git-gui gitk libgnome-keyring-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring
git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
git config --global core.autocrlf input
git lfs install

echo '> Install python'
sudo apt-get -y install python3 python3-pip

echo '> Install docker'
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli
sudo usermod -aG docker "$USER"
echo '> Install docker-compose'
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo '> Install VIM'
sudo apt-get -y install vim

echo "> Install sublime"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get -y install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get -y install sublime-text

echo '> Install latest Java'
sudo apt-get -y install default-jdk

if [[ -n $INSTALL_INTELLIJ ]]; then
  echo '> Install Intellij'
  wget -O /tmp/idea-install.tar.gz 'https://download.jetbrains.com/idea/ideaIU-2019.2.3.tar.gz'
  sudo tar -C /opt -xvzf /tmp/idea-install.tar.gz
  sudo mv /opt/idea-* /opt/idea
  sudo chown -R root:sudo /opt/idea
  sudo chmod -R ug+rw /opt/idea
  printf '[Desktop Entry]
    Version=1.0
    Type=Application
    Name=IntelliJ IDEA Ultimate Edition
    Icon=/opt/idea/bin/idea.svg
    Exec="/opt/idea/bin/idea.sh" %%f
    Comment=Capable and Ergonomic IDE for JVM
    Categories=Development;IDE;
    Terminal=false
    StartupWMClass=jetbrains-idea' | sudo tee /usr/share/applications/jetbrains-idea.desktop > /dev/null
fi

echo "> Install KeepassXc"
sudo apt-get -y install keepassxc

echo "> Install Meld"
sudo apt-get -y install meld

echo "> Install Filezilla"
sudo apt-get -y install filezilla

echo "> Install 7zip"
sudo apt-get -y install p7zip p7zip-full

echo "> Install VLC"
sudo apt-get -y install vlc
sudo apt-get -y remove totem

echo '> Install Chrome'
wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb

echo '> Install Gimp'
sudo apt-get -y install gimp 

echo "> Install Virtualbox 6"
sudo apt-get -y remove virtualbox virtualbox-qt virtualbox-dkms
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
sudo apt-get update
sudo apt-get -y install virtualbox-6.0

echo "> Install zsh"
sudo apt-get -y install zsh fonts-powerline
pip3 install thefuck

wget -O oh-my-zsh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sudo chmod u+x oh-my-zsh
./oh-my-zsh --unattended
rm -rf oh-my-zsh
sed -i "/^ZSH_THEME/s/\".*\"/\"agnoster\"/" ~/.zshrc
sed -i "/^plugins/s/(.*)/(gitfast gradle mvn pip python ubuntu thefuck docker docker-compose shrink-path)/" ~/.zshrc
touch ~/.zshenv
echo 'PATH=~/.local/bin:${PATH}' > ~/.zshenv
echo "DEFAULT_USER=${USER}" > ~/.zshenv
sudo chsh -s /usr/bin/zsh "$USER"
sed -i -e '$a\\nprompt_dir () {\n\tprompt_segment blue black "`shrink_path -f`"\n}' ~/.zshrc

echo "> Install cinnamon + custom theming + custom settings"
sudo add-apt-repository -u ppa:snwh/ppa -y
sudo add-apt-repository -u ppa:dyatlov-igor/google-cursors -y

sudo apt-get -y install cinnamon paper-icon-theme fonts-roboto fonts-noto bibata-oil-cursor-theme
sudo apt-get -y remove nautilus

wget -O /tmp/adapta-color.tar https://github.com/ivankra/adapta-gtk-theme-colorpack/releases/download/3.94.0.149-colorpack/adapta-gtk-theme-colorpack_3.94.0.149.tar
tar -xf /tmp/adapta-color.tar Adapta-Red
tar -xf /tmp/adapta-color.tar Adapta-Red-Nokto
sudo mv Adapta-Red /usr/share/themes/
sudo mv Adapta-Red-Nokto /usr/share/themes/

gsettings set org.cinnamon.desktop.interface icon-theme 'Paper'
gsettings set org.cinnamon.desktop.interface cursor-theme "Bibata_Oil"
gsettings set org.cinnamon.desktop.interface gtk-theme "Adapta-Red-Nokto"
gsettings set org.cinnamon.desktop.wm.preferences theme "Adapta-Red-Nokto"
gsettings set org.cinnamon.theme name "Adapta-Red-Nokto"
gsettings set org.cinnamon.settings-daemon.plugins.xsettings menus-have-icons "true"

gsettings set org.cinnamon.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
mkdir -p ~/.config/gtk-3.0/
printf "[Settings]\ngtk-application-prefer-dark-theme=true" | tee ~/.config/gtk-3.0/settings.ini

gsettings set org.nemo.desktop desktop-layout "true::true"
gsettings set org.nemo.desktop trash-icon-visible "true"
gsettings set org.nemo.desktop volumes-visible "true"
gsettings set org.nemo.desktop show-orphaned-desktop-icons "true"

sudo mkdir -p /usr/share/backgrounds/material/
sudo wget -O /usr/share/backgrounds/material/material-abstract-red.jpg https://w.wallhaven.cc/full/4x/wallhaven-4xg7gd.jpg
sudo wget -O /usr/share/backgrounds/material/red-panda.jpg https://w.wallhaven.cc/full/0w/wallhaven-0w2pr6.jpg
sudo wget -O /usr/share/backgrounds/material/red-pixel.jpg https://w.wallhaven.cc/full/g8/wallhaven-g88dl7.jpg

sudo rm /usr/share/gnome-background-properties/adwaita.xml
gsettings set org.cinnamon.desktop.background picture-uri  "file:////usr/share/backgrounds/material/material-abstract-red.jpg"
printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<\!DOCTYPE wallpapers SYSTEM \"cinnamon-wp-list.dtd\">
<wallpapers>
   <wallpaper deleted=\"false\">
      <name>Material Abstract Red</name>
      <filename>/usr/share/backgrounds/material/material-abstract-red.jpg</filename>
      <options>zoom</options>
      <shade_type>solid</shade_type>
      <pcolor>#a90000</pcolor>
      <scolor>#000000</scolor>
   </wallpaper>
   <wallpaper deleted=\"false\">
      <name>Red Panda</name>
      <filename>/usr/share/backgrounds/material/red-panda.jpg</filename>
      <options>zoom</options>
      <shade_type>solid</shade_type>
      <pcolor>#000000</pcolor>
      <scolor>#000000</scolor>
   </wallpaper>
   <wallpaper deleted=\"false\">
      <name>Ped Pixels</name>
      <filename>/usr/share/backgrounds/material/red-pixel.jpg</filename>
      <options>zoom</options>
      <shade_type>solid</shade_type>
      <pcolor>#000000</pcolor>
      <scolor>#000000</scolor>
   </wallpaper>
</wallpapers>\n" | sudo tee /usr/share/gnome-background-properties/material.xml > /dev/null


gsettings set org.cinnamon.desktop.screensaver screensaver-name 'xscreensaver@cinnamon.org'
gsettings set org.cinnamon.desktop.screensaver screensaver-webkit-theme 'webkit-stars@cinnamon.org'
gsettings set org.cinnamon.desktop.screensaver xscreensaver-hack 'binaryring'

gsettings set org.cinnamon favorite-apps "['google-chrome.desktop', 'thunderbird.desktop', 'cinnamon-settings.desktop', 'org.gnome.Terminal.desktop', 'nemo.desktop']"

gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar "false"


if [[ -n $INSTALL_CURA ]]; then
  echo '> Install CURA'
  sudo wget -O /usr/local/bin/Ultimaker_Cura-4.3.0.AppImage https://software.ultimaker.com/cura/Ultimaker_Cura-4.3.0.AppImage
  sudo chmod +x /usr/local/bin/Ultimaker_Cura-4.3.0.AppImage
  sudo wget -O /usr/share/icons/cura.png https://raw.githubusercontent.com/Ultimaker/Cura/master/icons/cura-128.png
  printf '[Desktop Entry]
  Version=4.3.0
  Name=Cura
  Comment=Ultimaker Cura 4.3.0 High-Performance 3D printing software
  Exec=/usr/local/bin/Ultimaker_Cura-4.3.0.AppImage
  Icon=/usr/share/icons/cura.png
  Terminal=false
  Type=Application
  Categories=Utility;Application;Development;' | sudo tee /usr/share/applications/Cura.desktop > /dev/null
fi

echo '> Setup keystrokes'
gsettings set org.cinnamon.desktop.keybindings.wm begin-move "[]"
gsettings set org.cinnamon.desktop.keybindings.wm begin-resize"[]"
gsettings set org.cinnamon.desktop.keybindings.wm begin-unmaximize "[]"
gsettings set org.cinnamon.desktop.keybindings.media-keys screensaver "['<Super>l', 'XF86ScreenSaver']"

echo '> Setup window tiles'
gsettings set org.cinnamon.muffin tile-maximize true

echo '> Setup sounds'
gsettings set org.cinnamon.sounds notification-enabled true
gsettings set org.cinnamon.sounds notification-file '/usr/share/sounds/freedesktop/stereo/bell.oga'
gsettings set org.cinnamon.sounds plug-enabled true
gsettings set org.cinnamon.sounds plug-file '/usr/share/sounds/freedesktop/stereo/device-added.oga'
gsettings set org.cinnamon.sounds unplug-enabled true
gsettings set org.cinnamon.sounds unplug-file '/usr/share/sounds/freedesktop/stereo/device-removed.oga'

echo '> Hide gnome settings in cinnamon'
printf 'NotShowIn=X-Cinnamon;' | sudo tee -a '/usr/share/applications/gnome-session-properties.desktop'

echo '> Remove spam launcher icons'
sudo rm /usr/share/applications/com.canonical.launcher.amazon.desktop

echo '> Clean up'
sudo apt-get -y autoremove

echo ''
echo '> Please logout and login again to see the new theming and use docker!'
