#!/bin/bash
# INFO: Please use Bash to run this Installer
#
# Bing-Desktop-Wallpaper-Changer
# BDWC Installer Copyright (C) 2017~ NKS (nks15)
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
INSTALLER_VERSION="v3.3.1-release"
INSTALLER_FULL_NAME="$STNAME Installer $INSTALLER_VERSION"
INSTALLER_NAME="$STNAME Installer"
INSTALLER_ICONS="$(ls $PWD/icon | sed 's/.svg//g' | sed -n -e '$!H;${H;g;s/\n/ /gp;}') None"
# For security reasons, Developer Mode has to be disabled automatically
INSTALLER_DEVELOPER_MODE=false
# Required to be installed in order to run main.py
# This list was in 'requirements.txt' before we merged into the Installer
INSTALLER_NEEDED_REQUIREMENTS="python-lxml python-bs4 python-gi python-gi-cairo"
# The system's Package Manager
# This is a dummy value and will make errors if not refreshed, so use detect_package_mgr later!
PACKAGE_MANAGER=unknown
# The Operating System
# This is a dummy value and will make errors if not refreshed, so use detect_os later!
OS=unknown
DISTRIBUTION=unknown
####
#### Ends Startup task.
####
#### Starts definition.
####
info_license() {
  # Prints license
  if [ "$1" != "--no-warning" ]; then
    echo "!!!! WE DO NOT RECOMMEND VIEWING LICENSE IN HERE !!!!"
    echo "!!!! PLEASE USE 'installer.sh --version' INSTEAD !!!!"
    echo ""
  fi
  cat $BDWC_LICENSE
}

info_readme() {
  # Prints readme
  echo "!!!! WE DO NOT RECOMMEND VIEWING README IN HERE !!!!"
  echo "!!!! PLEASE VIEW FROM THE GITHUB WEBSITE INSTEAD !!!!"
  echo ""
  cat $BDWC_README
}

info_main() {
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

info_help() {
  # Prints help about installer and tasks
  echo "Usage: installer.sh [OPTION]..."
  echo "       installer.sh [OPTION=*]..."
  echo ""
  echo " --help                display help about the Installer and tasks"
  echo " --version             display the Installer version"
  echo " --license             display LICENSE"
  echo " --readme              display README.md"
  echo " --detect              detect previous $UPNAME installation"
  echo " --install             install $UPNAME"
  echo " --uninstall           uninstall $UPNAME"
  echo " --update              update $UPNAME (needs git)"
  echo " --execute             run $UPNAME"
  echo ""
  echo " For developers:"
  echo " --enable-devmode    enables Developer Mode"
  echo " --disable-devmode   disables Developer Mode"
  echo " --run-installer-command=*    runs internal functions or shell commands"
  echo ""
  echo " * Note that Developer Mode is disabled automatically when the Installer starts (because of security reasons),"
  echo " those who wish to run developer tasks will always have to put --enable-devmode in front of OPTION."
  echo " For example, installer.sh --enable-devmode [DEVELOPER_OPTION/TASKS]"
  echo ""
  echo " * To directly run internal functions or shell commands, first you need to enable Developer Mode and use --run-installer-command."
  echo " For example, installer.sh --enable-devmode --run-installer-command=[YOUR COMMAND]"
  echo ""
  echo " * For more information, please visit:"
  echo " GitHub: <https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer>"
  echo ""
  echo " * And you know what? #This_Installer_can_moo (Try to find the Easter Egg!)"
}

info_version() {
  # Prints version info
  echo "$INSTALLER_FULL_NAME"
  echo "Installer Copyright (C) 2017~  NKS (nks15)"
  echo ""
  echo "$UPNAME"
  info_license --no-warning
}

info_alert() {
  # Prints alerts
  echo "Installer: $1!"
  echo "Try 'installer.sh $2' $3."
}

info_error() {
  # Prints errors and exit
  echo ""
  echo "Installer: Error $1!"
  exit 0
}

info_finish() {
  # Prints finish text
  echo ""
  echo ""
  echo "Finished!!"
  echo ""
}

info_install() {
  # Prints install text
  echo ""
  echo "Installing..."
  echo ""
}

uninstall_main() {
  # Completely removes/uninstalles Bing-Desktop-Wallpaper-Changer in this host system
  if [ "$1" != "--no-echo-text" ]; then
    echo "Completely removing Bing-Desktop-Wallpaper-Changer in $HOSTNAME..."
  fi
  sudo rm -rfv $HOME/$NAME
  sudo rm -rfv /opt/$NAME
  sudo rm -v $LINKTO/$TERMNAME
  sudo rm -v $AUTOSTART/bdwc-autostart.desktop
  sudo rm -v $AUTOSTART/bing-desktop-wallpaper-changer.desktop
  sudo rm -v /usr/share/applications/bdwc-launcher.desktop
}

update_main() {
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

detect_os() {
  if [ "$1" == "--verbose" ]; then
    echo "Detecting the Operating System..."
  fi

  # Detect the Operating System (In most cases, GNU/Linux)
  OS=$(uname -o)

  # Detect Linux distribution #####(BETA)#####
  if [ $(cat /etc/issue | grep ' \n \l') != ""]; then

    # /etc/issue method. will not work if the user modified it.
    DISTRIBUTION=$(cat /etc/issue | sed 's|[\]||g' | sed -r 's|.{4}$||')

  elif [ $(which lsb_release) != "" ]; then

    # use lsb_release to find out the distro name.
    DISTRIBUTION=$(lsb_release -d | sed 's|Description:||g' | sed 's|"	"||g')

  else

    # Just say Linux [Kernel version] in order to prevent errors.
    DISTRIBUTION="$(uname) $(uname -r)"

  fi

  if [ "$1" == "--verbose" ]; then
    echo ""
    echo "Operating System: $OS"
    echo "Linux Distribution: $DISTRIBUTION"
  fi
}

detect_package_mgr() {
  # Detect the system's package manager
  if [ "$1" == "--verbose" ]; then
    echo "Detecting the Package manager..."
  fi

  if [ $(which apt-get) != "" ]; then
    PACKAGE_MANAGER=apt-get
  elif [ $(which pip) != "" ]; then
    PACKAGE_MANAGER=pip
  elif [ $(which yum) != "" ]; then
    PACKAGE_MANAGER=yum
  else
    PACKAGE_MANAGER=unknown
  fi

  if [ "$1" == "--verbose" ]; then
    echo ""
    echo "Package manager: $PACKAGE_MANAGER"
  fi
}

detect_previous_install() {
  # Detect previous Bing-Desktop-Wallpaper-Changer installation
  echo "Detecting previous installation..."
  INSTALLER_IS_BDWC_INSTALLED_IN_A=$(ls $HOME | grep -i $NAME)
  INSTALLER_IS_BDWC_INSTALLED_IN_B=$(ls /opt | grep -i $NAME)
  INSTALLER_BDWC_INSTALLED=false
  INSTALLER_BDWC_INSTALLED_PATH=""

  if [ "$INSTALLER_IS_BDWC_INSTALLED_IN_A" != "" ]; then
      INSTALLER_BDWC_INSTALLED=true
      INSTALLER_BDWC_INSTALLED_PATH="$HOME/$NAME $INSTALLER_BDWC_INSTALLED_PATH"
  elif [ "$INSTALLER_IS_BDWC_INSTALLED_IN_B" != "" ]; then
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

find_error() {
  # Find errors and alerts them
  if [ "$(ls | grep LICENSE)" == "" ]; then
    info_error "1 (License file not found)"
  elif [ "$(ls | grep bin)" == "" ]; then
    info_error "2 (Binary folder not found)"
  elif [ "$PACKAGE_MANAGER" == unknown ]; then
    info_error "3 (Unknown package manager. Please report to GitHub!)"
  elif [ "$OS" == unknown ]; then
    info_error "4 (Unknown operating system. Please report to GitHub!)"
  elif [ "$DISTRIBUTION" == unknown ]; then
    info_error "5 (Unknown Linux distribution. Please report to GitHub!)"
  fi
}

easter_egg() {
  # Easter Egg!
  # Any new ideas is welcome
  # * "fortune | cowsay" looks good too
  if [ "$PACKAGE_MANAGER" == apt-get ]; then
    apt-get moo
  else
    echo "Moooooooooooooo"
    echo "Any new Easter Egg ideas is welcome"
  fi
}

ask_sudo() {
  # Asks user to grant Superuser permission
  echo "Asking root(sudo) privilege..."
  echo " $INSTALLER_NAME needs Superuser permissions to continue and run this task."
  echo " Don't worry! I will never use Superuser permissions to do bad things!"
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

ask_config() {
  echo ""
  echo "Asking configuration data..."
  echo ""
  echo ""

  # Installation path
  echo "Where do you want to install $UPNAME?"
  echo " * Entering 'opt' or pressing Enter or leaving this blank will install in /opt/$NAME (recommended)"
  echo " * Entering 'home' will install in $HOME/$NAME"
  echo -n "  Install $UPNAME in (opt/home)? : "
  read answer
  if echo "$answer" | grep -iq "^home" ;then
      INSTALLPATH=$HOME/$NAME
      INSTALLPATH_SMALL=$HOME
  else
      INSTALLPATH=/opt/$NAME
      INSTALLPATH_SMALL=/opt
  fi

  # Symlink
  echo ""
  echo "Should I create $NAME symlink to $LINKTO/$TERMNAME so you could easily execute it?"
  echo -n "  Create symlink for easy execution, e.g. in Terminal (y/n)? : "
  read answer
  if echo "$answer" | grep -iq "^y" ;then
      PYSYMLINK=true
  else
      PYSYMLINK=false
  fi

  # Desktop launcher
  echo ""
  echo "Should I create $NAME desktop launcher to the Application List/Dock/Panel/Menu/etc?"
  echo "If you do so, you can launch and execute $NAME very easily by clicking the desktop icon (like Firefox or System Settings)."
  echo -n "  Create desktop launcher for easy execution, e.g. on the Desktop (y/n)? : "
  read answer
  if echo "$answer" | grep -iq "^y" ;then
      DESKTOP=true
  else
      DESKTOP=false
  fi

  # Login autostart
  echo ""
  echo "Should $NAME needs to autostart when you log in? (Add in Startup Application)"
  echo -n "  Add in Startup Application (y/n)? : "
  read answer
  if echo "$answer" | grep -iq "^y" ;then
      STARTUP=true
  else
      STARTUP=false
  fi

  # Icon
  echo ""
  if [ $DESKTOP == true ]; then
    echo "Choose the icon for the Notification and the Desktop launcher..."
  else
    echo "Choose the icon for the Notification..."
  fi
  echo " * Operating System: $OS | Linux Distribution: $DISTRIBUTION *"
  echo ""
  echo " %% Available Icons:$INSTALLER_ICONS %%"
  echo ""
  echo " ## PLEASE DO NOT PRESS ENTER or INPUT ANY UNNEEDED WORDS! ##"
  echo " ## Please input the item you want in the exact form listed at (above) Available Icons. (Case sensitive!) ##"
  echo " ## e.g. type *Bing* if you want Bing icon (recommended) or *None* to remove icon. ##"
  echo ""

  echo -n "  Choose a Icon : "
  read answer
  ICON=$answer

  # Check ICON value to see if it's correct
  ICON_LIST=$(echo $INSTALLER_ICONS | sed 's/ /^?$*+!4#^/g')
  ICON_INTEGRITY=$(echo $ICON_LIST | grep "$ICON")

  if [ "$ICON" == "" ]; then
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    info_error "33 (Blank Icon value. Maybe you pressed the Enter key...)"
  elif [ "$ICON_INTEGRITY" == "" ]; then
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    info_error "33-2 (Mistyped or incorrect Icon value. Please check what you have typed...)"
  fi
}

install_packages() {
  echo ""
  echo "In order to prevent errors and run $UPNAME, we need to install some packages."
  echo "Using $PACKAGE_MANAGER to install..."
  echo ""

  if [ $PACKAGE_MANAGER == apt-get ]; then
    sudo $PACKAGE_MANAGER install $INSTALLER_NEEDED_REQUIREMENTS -y
  else
    sudo $PACKAGE_MANAGER install $INSTALLER_NEEDED_REQUIREMENTS
  fi
}

install_system() {
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

install_set_files() {
  echo ""
  echo "Setting desktop files..."

  if [ $PYSYMLINK == true ]; then
    sudo sed -i "s|Exec=[/a-z/a-z]*|Exec=$LINKTO/$TERMNAME|g" "$INSTALLPATH/bin/bdwc-launcher.desktop"
    sudo sed -i "s|Exec=[/a-z/a-z]*|Exec=$LINKTO/$TERMNAME|g" "$INSTALLPATH/bin/bdwc-autostart.desktop"
  else
	sudo sed -i "s|Exec=[/a-z/a-z]*|Exec=$INSTALLPATH/main.py|g" "$INSTALLPATH/bin/bdwc-launcher.desktop"
	sudo sed -i "s|Exec=[/a-z/a-z]*|Exec=$INSTALLPATH/main.py|g" "$INSTALLPATH/bin/bdwc-autostart.desktop"
  fi

  echo "File setup done."
}

install_set_icon() {
  echo ""
  echo "Setting icons..."

  if [ "$ICON" == "None" ]; then
    echo "Icon set as $ICON"
    sudo sed -i "s|app_notification = Notify.Notification.new(summary, str(body), icon)|app_notification = Notify.Notification.new(summary, str(body))|g" "$INSTALLPATH/main.py"
    sudo sed -i "s|Icon=/dev/null||g" "$INSTALLPATH/bin/bdwc-launcher.desktop"
    sudo sed -i "s|Icon=/dev/null||g" "$INSTALLPATH/bin/bdwc-autostart.desktop"
  else
    sudo cp -vf $INSTALLPATH/icon/$ICON.svg $INSTALLPATH/icon.svg && echo "Icon set as $ICON."
    sudo sed -i "s|Icon=/dev/null|Icon=$INSTALLPATH/icon.svg|g" "$INSTALLPATH/bin/bdwc-launcher.desktop"
    sudo sed -i "s|Icon=/dev/null|Icon=$INSTALLPATH/icon.svg|g" "$INSTALLPATH/bin/bdwc-autostart.desktop"
  fi
}

install_symlink() {
  if [ $PYSYMLINK == true ]; then
      echo ""
      echo "Creating symlink for easy execution..."

      sudo rm -v $LINKTO/$TERMNAME
      sudo ln -sv $INSTALLPATH/main.py $LINKTO/$TERMNAME
  fi
}

install_add_desktop_launcher() {
  if [ $DESKTOP == true ]; then
      echo ""
      echo "Adding $NAME Desktop Launcher..."

      sudo mv -vf $INSTALLPATH/bin/bdwc-launcher.desktop /usr/share/applications/bdwc-launcher.desktop
      sudo chmod +x /usr/share/applications/bdwc-launcher.desktop
  fi
}

install_add_startup() {
  if [ $STARTUP == true ]; then
      echo ""
      echo "Adding $NAME in Startup Application..."

      sudo mkdir -pv $AUTOSTART
      sudo cp -vf $INSTALLPATH/bin/bdwc-autostart.desktop $AUTOSTART/bdwc-autostart.desktop
  fi
}

install_set_python_script() {
  echo ""
  echo "Setting scripts..."
  sudo sed -i "s|/path/to/bing-desktop-wallpaper-changer|$INSTALLPATH|g" "$INSTALLPATH/main.py"
  sudo sed -i "s|replace with the actual path to the bing-desktop-wallpaper-changer folder|setup done to $INSTALLPATH by $INSTALLER_FULL_NAME|g" "$INSTALLPATH/main.py"
}

install_remove_unneeded() {
  # Clean up the locally installed BDWC
  echo ""
  echo "Removing unneeded things..."
  sudo rm -rfv $INSTALLPATH/bin
  sudo rm -rfv $INSTALLPATH/.git
  sudo rm -v $INSTALLPATH/.gitignore
}

execute() {
  echo ""
  echo "Executing $NAME..."
  if [ $PYSYMLINK == true ]; then
      python $LINKTO/$TERMNAME
  else
      python $INSTALLPATH/main.py
  fi
}

install_main() {
  ask_sudo
  echo ""
  detect_previous_install --remove-detected
  echo ""
  ask_config
  info_install
  install_packages
  install_system
  install_set_files
  install_set_icon
  install_symlink
  install_add_desktop_launcher
  install_add_startup
  install_set_python_script
  install_remove_unneeded
  execute
  info_finish
}
####
#### Ends definition.
####
#### Starts normal tasks.
####
# Prints main info
info_main

# Detects package manager and operating system
#  Environment detection is here (and not in install_main)
#  because many tasks rely on this (like Easter Egg)
detect_os
detect_package_mgr

# Try to find errors
find_error

# Check if argument is smaller then 1
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
    --detect)
    detect_previous_install
    shift
    ;;
    --install)
    install_main
    shift
    ;;
    --uninstall)
    ask_sudo
    echo ""
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
#
