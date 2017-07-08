#!/bin/bash
# INFO: Please use Bash to run this Installer
#
# Bing-Desktop-Wallpaper-Changer
# BDWC Installer Copyright (C) 2017~  NKS (nks15)
#
#### Starts Startup task.
#### INFO: DO NOT EDIT!
####
## Variable definition
NAME=bing-desktop-wallpaper-changer
UPNAME=Bing-Desktop-Wallpaper-Changer
STNAME=BDWC
TERMNAME=bingwallpaper
LINKTO=/usr/bin
AUTOSTART=$HOME/.config/autostart
## BDWC variable definition
BDWC_LICENSE=$PWD/LICENSE
BDWC_README=$PWD/README.md
## BDWC Installer variable definition
INSTALLER_VERSION="v3_beta2"
INSTALLER_FULL_NAME="$STNAME Installer $INSTALLER_VERSION"
INSTALLER_NAME="$STNAME Installer"
# For security reasons, Developer Mode has to be disabled automatically
INSTALLER_DEVELOPER_MODE=false
# Required to be installed in order to run main.py
# This list was in 'requirements.txt' before we merged into the Installer
INSTALLER_NEEDED_REQUIREMENTS="python-lxml python-bs4 python-gi python-gi-cairo"
# The system's Package Manager
# This is a dummy value and will make errors if not refreshed, so use detect_package_mgr later!
INSTALLER_PACKAGE_MANAGER=unknown
####
#### Ends Startup task.
####
#### Starts Function definition.
####
function info_license {
  # Prints license
  if [ "$1" != "--no-warning" ]; then
    echo "!!!! WE DO NOT RECOMMEND VIEWING LICENSE IN HERE !!!!"
    echo "!!!! PLEASE USE 'installer.sh --version' INSTEAD !!!!"
    echo ""
  fi
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
  # Prints help about installer and tasks
  echo "Usage: installer.sh [OPTION]..."
  echo "       installer.sh [OPTION=*]..."
  echo ""
  echo " --help              displays help about the Installer and tasks"
  echo " --version           displays the Installer version"
  echo " --license           displays LICENSE"
  echo " --readme            displays README.md"
  echo " --detect-install    detects previous $UPNAME installation"
  echo " --install           installs $UPNAME"
  echo " --uninstall         uninstalls $UPNAME"
  echo " --update            updates $UPNAME (needs git)"
  echo " --execute           runs $UPNAME"
  echo ""
  echo " For developers:"
  echo " --enable-devmode    enables Developer Mode"
  echo " --disable-devmode   disables Developer Mode"
  echo " --run-installer-command=*    runs internal functions or shell commands"
  echo ""
  echo " Note that Developer Mode is disabled automatically when the Installer starts (because of security reasons),"
  echo " those who wish to run developer tasks will always have to put --enable-devmode in front of OPTION."
  echo " For example, installer.sh --enable-devmode [DEVELOPER_OPTION/TASKS]"
  echo ""
  echo " To directly run internal functions or shell commands, first you need to enable Developer Mode and use --run-installer-command."
  echo " For example, installer.sh --enable-devmode --run-installer-command=[YOUR COMMAND]"
  echo ""
  echo " For more information, please visit:"
  echo " GitHub: <https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer>"
  echo ""
  echo " And you know what? #This_Installer_can_moo (Try to find the Easter Egg!)"
}

function info_version {
  # Prints version info
  echo "$INSTALLER_FULL_NAME"
  echo "Installer Copyright (C) 2017~  NKS (nks15)"
  echo ""
  echo "$UPNAME"
  info_license --no-warning
}

function info_alert {
  # Prints alerts
  echo "Installer: $1!"
  echo "Try 'installer.sh $2' $3."
}

function info_error {
  # Prints errors and exit
  echo ""
  echo "Installer: Error $1!"
  exit 0
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

function uninstall_main {
  # Completely removes/uninstalles Bing-Desktop-Wallpaper-Changer in this host system
  if [ "$1" != "--no-echo-text" ]; then
    echo "Completely removing Bing-Desktop-Wallpaper-Changer in $HOSTNAME..."
  fi
  sudo rm -rfv $HOME/$NAME
  sudo rm -rfv /opt/$NAME
  sudo rm -v $LINKTO/$TERMNAME
  sudo rm -v $AUTOSTART/bing-desktop-wallpaper-changer.desktop
}

function update_main {
  # Updates local BDWC using git
  # method used: https://help.github.com/articles/syncing-a-fork/
  #
  # For Developers!
  echo "Updating local $UPNAME..."
  echo " Adding remote..."
  git remote add upstream https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer.git
  echo " Added remote:"
  git remote -v
  echo " Fetching upstream repository..."
  git fetch upstream
  echo " Checkout local master branch..."
  git checkout master
  echo " Merging the changes..."
  git merge upstream/master
  # Finish
  info_finish
  echo "Now you can use 'installer.sh --install' to finish installing to $HOSTNAME"
}

function detect_package_mgr {
  # Detect the system's package manager
  if [ "$1" == "--verbose" ]; then
    echo "Detecting package manager..."
  fi

  if [ $(which apt-get) != "" ]; then
    INSTALLER_PACKAGE_MANAGER=apt-get
  else
    if [ $(which rpm) != "" ]; then
      INSTALLER_PACKAGE_MANAGER=rpm
    else
      if [ $(which pip) != "" ]; then
        INSTALLER_PACKAGE_MANAGER=pip
      else
        INSTALLER_PACKAGE_MANAGER=unknown
      fi
    fi
  fi

  if [ "$1" == "--verbose" ]; then
    echo ""
    echo "Package manager: $INSTALLER_PACKAGE_MANAGER"
  fi
}

function detect_previous_install {
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
      if [ "$1" == "--remove-detected" ]; then
        echo ""
        echo " Removing previous installations in order to prevent conflicts..."
        uninstall_main --no-echo-text
      fi
  fi
}

function find_error {
  # Find errors and alerts them
  if [ "$(ls | grep LICENSE)" == "" ]; then
    info_error "1 (License file not found)"
  fi

  if [ "$(ls | grep bin)" == "" ]; then
    info_error "2 (Binary folder not found)"
  fi

  if [ $INSTALLER_PACKAGE_MANAGER == unknown ]; then
    info_error "3 (Unknown package manager. Please report to GitHub!)"
  fi
}

function easter_egg {
  # Easter Egg!
  # Any new ideas is welcome
  # * "fortune | cowsay" looks good too
  if [ "$INSTALLER_PACKAGE_MANAGER" == apt-get ]; then
    apt-get moo
  else
    echo "Moooooooooooooo"
    echo "Any new Easter Egg ideas is welcome"
  fi
}

function ask_sudo {
  # Asks user to grant Superuser permission
  echo "Asking sudo privilege..."
  echo " $INSTALLER_NAME needs Superuser permissions to continue and run this task."
  echo " We will never use Superuser permissions to do bad things!"
  echo ""
  
  # Check if root permission is granted
  sudo echo " Root privilege status:"
  INSTALLER_SUDO_PRIVILEGE=$(sudo id -u)

  if [ $INSTALLER_SUDO_PRIVILEGE == 0 ]; then
    echo " #Root!, User id = $INSTALLER_SUDO_PRIVILEGE"
  else
    info_error "4 (Root permission not granted)"
  fi
}

function ask_config {
  echo "Asking configuration data..."
  echo ""

  echo "Where do you want to install $UPNAME?"
  echo "   Entering 'opt' or leaving input blank will install in /opt/$NAME"
  echo "   Entering 'home' will install in $HOME/$NAME"
  echo -n "  Install $UPNAME in (opt/home)? : "
  read answer
  if echo "$answer" | grep -iq "^home" ;then
      INSTALLPATH=$HOME/$NAME
      INSTALLPATH_SMALL=$HOME
  else
      INSTALLPATH=/opt/$NAME
      INSTALLPATH_SMALL=/opt
  fi

  echo ""
  echo "Should we create $NAME symlink to $LINKTO/$TERMNAME so you could easily execute it?"
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

function install_packages {
  echo ""
  echo "In order to prevent errors and run $UPNAME, we need to install some packages."
  echo " Using $INSTALLER_PACKAGE_MANAGER to install..."
  sudo $INSTALLER_PACKAGE_MANAGER install $INSTALLER_NEEDED_REQUIREMENTS
}

function install_system {
  echo ""
  echo "Installing in $INSTALLPATH..."

  if [ $INSTALLPATH_SMALL == $HOME ]; then
    mkdir -v $INSTALLPATH
  else
    sudo mkdir -v $INSTALLPATH
  fi

  sudo cp -Rvf * $INSTALLPATH
  # Restore main.py to original directory
  sudo mv -vf $INSTALLPATH/bin/main.py $INSTALLPATH/main.py
}

function install_symlink {
  if [ $PYSYMLINK == true ]; then
      echo ""
      echo "Creating symlink for easy execution..."

      sudo rm -v $LINKTO/$TERMNAME
      sudo ln -sv $INSTALLPATH/main.py $LINKTO/$TERMNAME
  fi
}

function install_add_startup {
  if [ $STARTUP == true ]; then
      echo ""
      echo "Adding $NAME in Startup Application..."

      if [ $PYSYMLINK == true ]; then
  	sudo sed -i "s|Exec=[/a-z/a-z]*|Exec=$LINKTO/$TERMNAME|g" "$INSTALLPATH/bin/bing-desktop-wallpaper-changer.desktop"
      else
	sudo sed -i "s|Exec=[/a-z/a-z]*|Exec=$INSTALLPATH/main.py|g" "$INSTALLPATH/bin/bing-desktop-wallpaper-changer.desktop"
      fi

      sudo mkdir -pv $AUTOSTART
      sudo cp -vf $INSTALLPATH/bin/bing-desktop-wallpaper-changer.desktop $AUTOSTART/bing-desktop-wallpaper-changer.desktop
  fi
}

function install_set_icon {
  echo ""
  echo "Setting icons..."
  sudo cp -vf $INSTALLPATH/bin/$ICON.svg $INSTALLPATH/icon.svg && echo "Icon set as $ICON."
}

function install_set_python_script {
  echo ""
  echo "Setting scripts..."
  sudo sed -i "s|/path/to/bing-desktop-wallpaper-changer|$INSTALLPATH|g" "$INSTALLPATH/main.py"
  sudo sed -i "s|replace with the actual path to the bing-desktop-wallpaper-changer folder|Replaced to $INSTALLPATH by $INSTALLER_FULL_NAME|g" "$INSTALLPATH/main.py"
}

function install_remove_unneeded {
  # Clean up the locally installed BDWC
  echo ""
  echo "Removing unneeded things..."
  sudo rm -rfv $INSTALLPATH/bin
  sudo rm -rfv $INSTALLPATH/.git
  sudo rm -v $INSTALLPATH/.gitignore
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

function install_main {
  ask_sudo
  echo ""
  detect_previous_install --remove-detected
  echo ""
  ask_config
  info_install
  install_packages
  install_system
  install_symlink
  install_add_startup
  install_set_icon
  install_set_python_script
  install_remove_unneeded
  execute
  info_finish
}
####
#### Ends Function definition.
####
#### Starts normal tasks.
####
# Prints main info
info_main

# Detect package manager
#  Package manager detection is here (and not in install_main)
#  because many tasks rely on this (like Easter Egg)
detect_package_mgr

# Try to find errors
find_error

# Check if arguments is smaller then 1
if [ "$#" -lt 1 ]; then
  info_alert "no tasks to do" "--help" "for more information"
  exit 0
fi

# Check arguments
for i in "$@"
do
case $i in
    --help)
    info_help
    shift
    ;;
    --version)
    info_version
    shift
    ;;
    --license)
    info_license
    shift
    ;;
    --readme)
    info_readme
    shift
    ;;
    --detect-install)
    detect_previous_install
    shift
    ;;
    --install)
    install_main
    shift
    ;;
    --uninstall)
    ask_sudo
    uninstall_main
    shift
    ;;
    --update)
    update_main
    shift
    ;;
    --execute)
    # Sets value
    PYSYMLINK=true
    # TODO: Find a good execute way that works on non-symlink location
    execute
    shift
    ;;
    --enable-devmode)
    INSTALLER_DEVELOPER_MODE=true
    shift
    ;;
    --disable-devmode)
    INSTALLER_DEVELOPER_MODE=false
    shift
    ;;
    --run-installer-command=*)
    FUNCTION_NAME="${i#*=}"
    if [ $INSTALLER_DEVELOPER_MODE == true ]; then
      echo "- Hello, Developer $USER on Host $HOSTNAME -"
      echo "INSTALLER_DEVELOPER_MODE = $INSTALLER_DEVELOPER_MODE"
      echo "FUNCTION_NAME (COMMAND) = $FUNCTION_NAME"
      echo ""
      $FUNCTION_NAME
    else
      info_alert "Developer Mode is disabled" "--enable-devmode" "to use developer tasks"
    fi
    shift
    ;;
    *)
      info_alert "unknown task" "--help" "for more information"
    ;;
esac
done
#### Ends normal tasks;
#
# BDWC Installer :)
