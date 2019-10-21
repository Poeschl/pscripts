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
  read -p '[C]ommunity Edition or [U]ltimate Edition ? ' -r
  if [[ $REPLY =~ ^[Uu]$ ]]; then
    INSTALL_INTELLIJ=2
  else 
    INSTALL_INTELLIJ=1
  fi
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
  if [ $INSTALL_INTELLIJ -eq 1 ]; then
    wget -O /tmp/idea-install.tar.gz 'https://download.jetbrains.com/idea/ideaIC-2019.2.3.tar.gz'
  elif [ $INSTALL_INTELLIJ -eq 2 ]; then
    wget -O /tmp/idea-install.tar.gz 'https://download.jetbrains.com/idea/ideaIU-2019.2.3.tar.gz'
  fi
  sudo tar -C /opt -xvzf /tmp/idea-install.tar.gz
  sudo mv /opt/idea-* /opt/idea
  echo -e '\e[32mExecute Intellij once to setup everything! Close it afterwards please\e[39m'
  /opt/idea/bin/idea.sh
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
sed -i "/env\szsh/d" oh-my-zsh
sed -i "/^s*chsh/d" oh-my-zsh
sed -i "/\tsetup_shell/d" oh-my-zsh
./oh-my-zsh
rm -rf oh-my-zsh
sed -i "/^ZSH_THEME/s/\".*\"/\"agnoster\"/" ~/.zshrc
sed -i "/^plugins/s/(.*)/(gitfast gradle mvn pip python ubuntu thefuck docker docker-compose shrink_path)/" ~/.zshrc
touch ~/.zshenv
echo 'PATH=~/.local/bin:${PATH}' > ~/.zshenv
echo "DEFAULT_USER=${USER}" > ~/.zshenv
sudo chsh -s /usr/bin/zsh $USER
sed -i -e '$a\\nprompt_dir () {\n\tprompt_segment blue black "`shrink_path -f`"\n}' ~/.zshrc

echo "> Install cinnamon + custom theming + custom settings"
sudo add-apt-repository -u ppa:snwh/ppa -y
sudo add-apt-repository -u ppa:tista/adapta -y
sudo add-apt-repository -u ppa:dyatlov-igor/google-cursors -y

sudo apt-get -y install cinnamon paper-icon-theme fonts-roboto fonts-noto adapta-gtk-theme bibata-oil-cursor-theme
sudo apt-get -y remove nautilus

gsettings set org.cinnamon.desktop.interface icon-theme 'Paper'
gsettings set org.cinnamon.desktop.interface cursor-theme "Bibata_Oil"
gsettings set org.cinnamon.desktop.interface gtk-theme "Adapta-Nokto"
gsettings set org.cinnamon.desktop.wm.preferences theme "Adapta-Nokto"
gsettings set org.cinnamon.theme name "Adapta-Nokto"
gsettings set org.cinnamon.settings-daemon.plugins.xsettings menus-have-icons "true"

gsettings set org.cinnamon.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
mkdir -p ~/.config/gtk-3.0/
printf "[Settings]\ngtk-application-prefer-dark-theme=true" | tee ~/.config/gtk-3.0/settings.ini

gsettings set org.nemo.desktop desktop-layout "true::true"
gsettings set org.nemo.desktop trash-icon-visible "true"
gsettings set org.nemo.desktop volumes-visible "true"
gsettings set org.nemo.desktop show-orphaned-desktop-icons "true"

gsettings set org.cinnamon panels-enabled "['1:0:bottom', '2:1:bottom']"
gsettings set org.cinnamon enabled-applets "['panel1:right:1:systray@cinnamon.org:0', 'panel1:left:0:menu@cinnamon.org:1', 'panel1:left:2:panel-launchers@cinnamon.org:3', 'panel1:left:3:window-list@cinnamon.org:4', 'panel1:right:2:keyboard@cinnamon.org:5', 'panel1:right:3:notifications@cinnamon.org:6', 'panel1:right:4:removable-drives@cinnamon.org:7', 'panel1:right:5:user@cinnamon.org:8', 'panel1:right:6:network@cinnamon.org:9', 'panel1:right:7:power@cinnamon.org:11', 'panel1:right:9:calendar@cinnamon.org:12', 'panel1:right:8:sound@cinnamon.org:13', 'panel2:left:0:window-list@cinnamon.org:15', 'panel2:right:0:calendar@cinnamon.org:16', 'panel3:left:0:window-list@cinnamon.org:17']"

gsettings set org.cinnamon.desktop.screensaver screensaver-name 'xscreensaver@cinnamon.org'
gsettings set org.cinnamon.desktop.screensaver screensaver-webkit-theme 'webkit-stars@cinnamon.org'
gsettings set org.cinnamon.desktop.screensaver xscreensaver-hack 'binaryring'

gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar "false"


if [[ -n $INSTALL_CURA ]]; then
  echo '> Install CURA'
  sudo wget -O /usr/local/bin/Ultimaker_Cura-4.3.0.AppImage https://software.ultimaker.com/cura/Ultimaker_Cura-4.3.0.AppImage
  sudo chmod +x /usr/local/bin/Ultimaker_Cura-4.3.0.AppImage
  sudo wget -O /usr/share/icons/cura.png https://raw.githubusercontent.com/Ultimaker/Cura/master/icons/cura-128.png
  sudo cp resources/Cura.desktop /usr/share/applications/
fi

ehoc '> Install python'
sudo apt-get -y python3 pip3

echo '> Clean up'
sudo apt-get -y autoremove

echo ''
echo '> Please logout and login again to see the new theming and use docker!'
