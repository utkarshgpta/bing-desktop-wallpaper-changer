#!/bin/bash
# INFO: ALWAYS USE bash FOR RUNNING THIS INSTALLER
#
# Bing-Desktop-Wallpaper-Changer
# BDWC Installer Copyright (C) 2017~  NKS (nks15)

# Variable definition
NAME=bing-desktop-wallpaper-changer
UPNAME=Bing-Desktop-Wallpaper-Changer
TERMNAME=bingwallpaper
LINKTO=/usr/bin
AUTOSTART=$HOME/.config/autostart
# BDWC variable definition
BDWC_LICENSE=$PWD/LICENSE
BDWC_README=$PWD/README.md
# BDWC Installer variable definition
INSTALLER_VERSION="Version 1.0"
INSTALLER_FULL_NAME="$UPNAME Installer ($INSTALLER_VERSION)"

function info_license {
  # Prints license
  cat $BDWC_LICENSE
}

function info_readme {
  # Prints readme
  echo "!!!! WE DO NOT RECOMMEND VIEWING README IN HERE !!!!"
  echo "!!!! PLEASE VIEW FROM THE GITHUB WEBSITE INSTEAD !!!!"
  echo ""
  cat $BDWC_README
}

function info_main {
  # Prints main information
  echo ""
  echo "$UPNAME"
  echo "$INSTALLER_FULL_NAME"
  echo ""
  echo "GitHub: <https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer>"
  echo "Contributors: <https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer/network/members>"
  echo ""
  echo ""
}

function info_help {
  # Prints info about installer
  echo "$USER" 
}

function info_finish {
  # Prints finish text
  echo ""
  echo ""
  echo "Finished!!"
  echo ""
}

function info_install {
  # Prints install text
  echo ""
  echo "Installing..."
  echo ""
}

function uninstall {
  # Completely removes/uninstalles Bing-Desktop-Wallpaper-Changer in host system
  echo "Completely removing Bing-Desktop-Wallpaper-Changer in host system ($HOSTNAME)..."
  sudo rm -rfv $HOME/$NAME
  sudo rm -rfv /opt/$NAME
  sudo rm -v $LINKTO/$TERMNAME
  sudo rm -v $AUTOSTART/bing-desktop-wallpaper-changer.desktop
}

function detect_previous {
  # Detect previous Bing-Desktop-Wallpaper-Changer installation
  echo "Detecting previous installation..."
  INSTALLER_IS_BDWC_INSTALLED_IN_A=$(ls $HOME | grep -i $NAME)
  INSTALLER_IS_BDWC_INSTALLED_IN_B=$(ls /opt | grep -i $NAME)
  INSTALLER_BDWC_INSTALLED=false
  INSTALLER_BDWC_INSTALLED_PATH=""

  if [ "$INSTALLER_IS_BDWC_INSTALLED_IN_A" != "" ]; then
      INSTALLER_BDWC_INSTALLED=true
      INSTALLER_BDWC_INSTALLED_PATH="$HOME/$NAME $INSTALLER_BDWC_INSTALLED_PATH"
  fi
  if [ "$INSTALLER_IS_BDWC_INSTALLED_IN_B" != "" ]; then
      INSTALLER_BDWC_INSTALLED=true
      INSTALLER_BDWC_INSTALLED_PATH="/opt/$NAME $INSTALLER_BDWC_INSTALLED_PATH"
  fi

  if [ "$INSTALLER_BDWC_INSTALLED" == "true" ]; then
      echo " Detected previous installation in:"
      echo "  $INSTALLER_BDWC_INSTALLED_PATH"
      echo ""
      echo " Removing previous installations in order to prevent conflicts..."
      uninstall
  fi
}

function detect_conflict {
  echo "Undefined"
}

function easter_egg {
  # Currently it's apt-get moo; Any new ideas welcome
  # "fortune | cowsay" looks good too
  apt-get moo
}

function ask_sudo {
  # Asks user to grant Superuser permission
  # sudo make me a sandwich
  echo "We need Superuser permission to continue the task."
  echo "We promise, We will never use Superuser permissions to do bad things!"
  sudo echo "Thanks!"
}

function ask_config {
  echo "* Asking configuration data..."
  echo ""

  echo "Where do you want to install $UPNAME?"
  echo " -Entering 'opt' or leaving input blank will install in /opt/$NAME"
  echo " -Entering 'home' will install in $HOME/$NAME"
  echo -n "  Install $UPNAME in (opt/home)? : "
  read answer
  if echo "$answer" | grep -iq "^home" ;then
      INSTALLPATH=$HOME/$NAME
  else
      INSTALLPATH=/opt/$NAME
  fi

  echo ""
  echo "Should I create $NAME symlink to $LINKTO/$TERMNAME so you could easily execute it?"
  echo -n "  Create symlink for easy execution, e.g. in Terminal (y/n)? : "
  read answer
  if echo "$answer" | grep -iq "^y" ;then
      PYSYMLINK=true
  else
      PYSYMLINK=false
  fi

  echo ""
  echo "Should $NAME needs to autostart when you log in? (Add in Startup Application)"
  echo -n "  Add in Startup Application (y/n)? : "
  read answer
  if echo "$answer" | grep -iq "^y" ;then
      STARTUP=true
  else
      STARTUP=false
  fi

  if [ "$(lsb_release -i | grep Ubuntu)" != "" ]; then
      ICON=Ubuntu
  else
      ICON=Bing
  fi

  # TODO : Add a lot of options
}

function install_main {
  # Time to find errors
  if [ "$(ls | grep LICENSE)" == "" ]; then
      echo "ERROR 1!"
      exit 0
  fi
  if [ "$(ls | grep bin)" == "" ]; then
      echo "ERROR 2!"
      exit 0
  fi

  INSTALLNEED=$(cat bin/requirements.txt)
  echo ""
  echo "In order to change wallpapers, we need to install '$INSTALLNEED'"
  echo "You only need to install them once."
  sudo apt-get install $INSTALLNEED

  echo ""
  echo "Installing in $INSTALLPATH..."
  mkdir $INSTALLPATH
  sudo cp -Rvf * $INSTALLPATH
  # Restore main.py to original directory
  sudo mv -vf $INSTALLPATH/bin/main.py $INSTALLPATH/main.py
}

function install_symlink {
  if [ $PYSYMLINK == true ]; then
      echo ""
      echo "Creating symlink for easy execution..."

      sudo ln -s $INSTALLPATH/main.py $LINKTO/$TERMNAME
      echo "$(ls $INSTALLPATH/main.py) symlinked in $(ls $LINKTO/$TERMNAME)"
  fi
}

function install_add_startup {
  if [ $STARTUP == true ]; then
      echo ""
      echo "Adding $NAME in Startup Application..."

      if [ $PYSYMLINK == true ]; then
  	sed -i "s|Exec=[/a-z/a-z]*|Exec=$LINKTO/$TERMNAME|g" "$INSTALLPATH/bin/bing-desktop-wallpaper-changer.desktop"
      else
	sed -i "s|Exec=[/a-z/a-z]*|Exec=$INSTALLPATH/main.py|g" "$INSTALLPATH/bin/bing-desktop-wallpaper-changer.desktop"
      fi

      cp -vf $INSTALLPATH/bin/bing-desktop-wallpaper-changer.desktop $AUTOSTART/bing-desktop-wallpaper-changer.desktop
  fi
}

function install_set_icon {
  echo ""
  echo "Setting icons..."
  echo "Icon set as $ICON."
  sudo cp -vf $INSTALLPATH/bin/$ICON.svg $INSTALLPATH/icon.svg
}

function install_set_python_script {
  echo ""
  echo "Setting python script..."
  sed -i "s|/path/to/bing-desktop-wallpaper-changer|$INSTALLPATH|g" "$INSTALLPATH/main.py"
  sed -i "s|replace with the actual path to the bing-desktop-wallpaper-changer folder|replaced to $INSTALLPATH by $INSTALLER_FULL_NAME|g" "$INSTALLPATH/main.py"
}

function execute {
  echo ""
  echo "Executing $NAME..."
  if [ $PYSYMLINK == true ]; then
      python $LINKTO/$TERMNAME
  else
      python $INSTALLPATH/main.py
  fi
}

# TODO : remove this
easter_egg
