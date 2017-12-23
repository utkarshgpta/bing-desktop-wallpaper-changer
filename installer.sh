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
AUTOSTART=$HOME/.config/autOStart
## BDWC variable definition
BDWC_LICENSE=$PWD/LICENSE
BDWC_README=$PWD/README.md
## BDWC Installer variable definition
INSTALLER_VERSION="v3.1"
INSTALLER_FULL_NAME="$STNAME Installer $INSTALLER_VERSION"
INSTALLER_NAME="$STNAME Installer"
# For security reasons, Developer Mode has to be disabled automatically
INSTALLER_DEVELOPER_MODE=false
# Required to be installed in order to run main.py
# This list was in 'requirements.txt' before we merged into the Installer
INSTALLER_NEEDED_REQUIREMENTS="python-lxml python-bs4 python-gi python-gi-cairo"
# The system's Package Manager
# This is a dummy value and will make errors if not refreshed, so use detect_package_mgr later!
PACKAGE_MANAGER=unknown
# The Operating System
# This is a dummy value and will make errors if not refreshed, so use detect_OS later!
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

info_opensource_license() {
  # Prints open source licenses
  echo ""
  echo "#### $INSTALLER_FULL_NAME includes some work from the following open source projects: ####"
  echo ""
  echo "[neofetch]"
  echo "https://github.com/dylanaraps/neofetch"
  echo ""
  cat "$PWD/bin/opensource-licenses/neofetch/LICENSE.md"
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
  echo " --opensource-license  print Open Source Licenses"
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
  echo " Note that Developer Mode is disabled automatically when the Installer starts (because of security reasons),"
  echo " thOSe who wish to run developer tasks will always have to put --enable-devmode in front of OPTION."
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

detect_os() {
  # Code: https://github.com/dylanaraps/neofetch
  # The MIT License (MIT)
  #
  # Copyright (c) 2016-2017 Dylan Araps
  #
  # Permission is hereby granted, free of charge, to any person obtaining a copy
  # of this software and associated documentation files (the "Software"), to deal
  # in the Software without restriction, including without limitation the rights
  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  # copies of the Software, and to permit persons to whom the Software is
  # furnished to do so, subject to the following conditions:
  #
  # The above copyright notice and this permission notice shall be included in all
  # copies or substantial portions of the Software.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # ITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  # SOFTWARE.
  kernel_name=$(uname -s)

  case "$kernel_name" in
        "Linux" | "GNU"*) OS="Linux" ;;
        "Darwin") OS="$(sw_vers -productName)" ;;
        *"BSD" | "DragonFly" | "Bitrig") OS="BSD" ;;
        "CYGWIN"* | "MSYS"* | "MINGW"*) OS="Windows" ;;
        "SunOS") OS="Solaris" ;;
        "Haiku") OS="Haiku" ;;
        "MINIX") OS="MINIX" ;;
        "AIX") OS="AIX" ;;
        "IRIX64") OS="IRIX" ;;
        *)
            printf "%s\n" "Unknown OS detected: '$kernel_name', aborting..." >&2
            printf "%s\n" "Open an issue on GitHub to add support for your OS." >&2
            exit 1
        ;;
  esac


  [[ "$DISTRIBUTION" ]] && return

  case "$OS" in
      "Linux" | "BSD" | "MINIX")
          if [[ "$(< /proc/version)" == *"MicrOSoft"* ||
              "$kernel_version" == *"MicrOSoft"* ]]; then
              case "$DISTRIBUTION_shorthand" in
                  "on")   DISTRIBUTION="$(lsb_release -sir) [Windows 10]" ;;
                  "tiny") DISTRIBUTION="Windows 10" ;;
                  *)      DISTRIBUTION="$(lsb_release -sd) on Windows 10" ;;
              esac

          elif [[ "$(< /proc/version)" == *"chrome-bot"* || -f "/dev/crOS_ec" ]]; then
              case "$DISTRIBUTION_shorthand" in
                  "on")   DISTRIBUTION="$(lsb_release -sir) [Chrome OS]" ;;
                  "tiny") DISTRIBUTION="Chrome OS" ;;
                   *)      DISTRIBUTION="$(lsb_release -sd) on Chrome OS" ;;
              esac

          elif [[ -f "/etc/redstar-release" ]]; then
              case "$DISTRIBUTION_shorthand" in
                  "on" | "tiny") DISTRIBUTION="Red Star OS" ;;
                  *) DISTRIBUTION="Red Star OS $(awk -F'[^0-9*]' '$0=$2' /etc/redstar-release)"
              esac

          elif [[ -f "/etc/siduction-version" ]]; then
              case "$DISTRIBUTION_shorthand" in
                  "on" | "tiny") DISTRIBUTION="Siduction" ;;
                  *) DISTRIBUTION="Siduction ($(lsb_release -sic))"
              esac

          elif type -p lsb_release >/dev/null; then
                case "$DISTRIBUTION_shorthand" in
                    "on")   lsb_flags="-sir" ;;
                    "tiny") lsb_flags="-si" ;;
                    *)      lsb_flags="-sd" ;;
                esac
                DISTRIBUTION="$(lsb_release $lsb_flags)"

          elif [[ -f "/etc/GoboLinuxVersion" ]]; then
              case "$DISTRIBUTION_shorthand" in
                  "on" | "tiny") DISTRIBUTION="GoboLinux" ;;
                  *) DISTRIBUTION="GoboLinux $(< /etc/GoboLinuxVersion)"
              esac

          elif type -p guix >/dev/null; then
              case "$DISTRIBUTION_shorthand" in
                  "on" | "tiny") DISTRIBUTION="GuixSD" ;;
                  *) DISTRIBUTION="GuixSD $(guix system -V | awk 'NR==1{printf $5}')"
              esac

          elif type -p crux >/dev/null; then
              DISTRIBUTION="$(crux)"
              case "$DISTRIBUTION_shorthand" in
                  "on")   DISTRIBUTION="${DISTRIBUTION//version}" ;;
                  "tiny") DISTRIBUTION="${DISTRIBUTION//version*}" ;;
              esac

          elif type -p tazpkg >/dev/null; then
              DISTRIBUTION="SliTaz $(< /etc/slitaz-release)"

          elif type -p kpt >/dev/null && \
               type -p kpm >/dev/null; then
              DISTRIBUTION="KSLinux"

          elif [[ -d "/system/app/" && -d "/system/priv-app" ]]; then
              DISTRIBUTION="Android $(getprop ro.build.version.release)"

          elif [[ -f "/etc/OS-release" || -f "/usr/lib/OS-release" ]]; then
              files=("/etc/OS-release" "/usr/lib/OS-release")

              # Source the OS-release file
              for file in "${files[@]}"; do
                  source "$file" && break
              done

              # Format the DISTRIBUTION name.
              case "$DISTRIBUTION_shorthand" in
                  "on") DISTRIBUTION="${NAME:-${DISTRIB_ID}} ${VERSION_ID:-${DISTRIB_RELEASE}}" ;;
                  "tiny") DISTRIBUTION="${NAME:-${DISTRIB_ID:-${TAILS_PRODUCT_NAME}}}" ;;
                  "off") DISTRIBUTION="${PRETTY_NAME:-${DISTRIB_DESCRIPTION}} ${UBUNTU_CODENAME}" ;;
              esac

              # Workarounds for DISTRIBUTIONs that go against the OS-release standard.
              [[ -z "${DISTRIBUTION// }" ]] && DISTRIBUTION="$(awk '/BLAG/ {print $1; exit}')" "${files[@]}"
              [[ -z "${DISTRIBUTION// }" ]] && DISTRIBUTION="$(awk -F'=' '{print $2; exit}')"  "${files[@]}"

          else
              for release_file in /etc/*-release; do
                  DISTRIBUTION+="$(< "$release_file")"
              done

              if [[ -z "$DISTRIBUTION" ]]; then
                  case "$DISTRIBUTION_shorthand" in
                      "on" | "tiny") DISTRIBUTION="$kernel_name" ;;
                      *) DISTRIBUTION="$kernel_name $kernel_version" ;;
                  esac
                  DISTRIBUTION="${DISTRIBUTION/DragonFly/DragonFlyBSD}"

                  # Workarounds for FreeBSD based DISTRIBUTIONs.
                  [[ -f "/etc/pcbsd-lang" ]] && DISTRIBUTION="PCBSD"
                  [[ -f "/etc/trueOS-lang" ]] && DISTRIBUTION="TrueOS"

                  # /etc/pacbsd-release is an empty file
                  [[ -f "/etc/pacbsd-release" ]] && DISTRIBUTION="PacBSD"
              fi
          fi
          DISTRIBUTION="$(trim_quotes "$DISTRIBUTION")"
          DISTRIBUTION="${DISTRIBUTION/'NAME='}"
      ;;
    esac

    # Get OS architecture.
    case "$OS" in
        "Solaris" | "AIX" | "Haiku" | "IRIX") machine_arch="$(uname -p)" ;;
        *) machine_arch="$(uname -m)" ;;

    esac
    if [[ "$OS_arch" == "on" ]]; then
        DISTRIBUTION+=" ${machine_arch}"
    fi

    [[ "${ASCII_DISTRIBUTION:-auto}" == "auto" ]] && \
    ASCII_DISTRIBUTION="$(trim "$DISTRIBUTION")"
}

detect_package_mgr() {
  # Detect the system's package manager
  if [ "$1" == "--verbOSe" ]; then
    echo "Detecting package manager..."
  fi

  if [ $(which apt-get) != "" ]; then
    PACKAGE_MANAGER=apt-get
  else
    if [ $(which rpm) != "" ]; then
      PACKAGE_MANAGER=rpm
    else
      if [ $(which pip) != "" ]; then
        PACKAGE_MANAGER=pip
      else
        PACKAGE_MANAGER=unknown
      fi
    fi
  fi

  if [ "$1" == "--verbOSe" ]; then
    echo ""
    echo "Package manager: $PACKAGE_MANAGER"
  fi
}

uninstall_main() {
  # Completely removes/uninstalles Bing-Desktop-Wallpaper-Changer in this hOSt system
  if [ "$1" != "--no-echo-text" ]; then
    echo "Completely removing Bing-Desktop-Wallpaper-Changer in $HOSTNAME..."
  fi
  sudo rm -rfv $HOME/$NAME
  sudo rm -rfv /opt/$NAME
  sudo rm -v $LINKTO/$TERMNAME
  sudo rm -v $AUTOSTART/bing-desktop-wallpaper-changer.desktop
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
  echo " Fetching upstream repOSitory..."
  git fetch upstream
  echo " Checkout local master branch..."
  git checkout master
  echo " Merging the changes..."
  git merge upstream/master
  # Finish
  info_finish
  echo "Now you can use 'installer.sh --install' to finish installing to $HOSTNAME"
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

find_error() {
  # Find errors and alerts them
  if [ "$(ls | grep LICENSE)" == "" ]; then
    info_error "1 (License file not found)"
  fi

  if [ "$(ls | grep bin)" == "" ]; then
    info_error "2 (Binary folder not found)"
  fi

  if [ $PACKAGE_MANAGER == unknown ]; then
    info_error "3 (Unknown package manager. Please report to GitHub!)"
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

ask_config() {
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
  echo "Should $NAME needs to autOStart when you log in? (Add in Startup Application)"
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

install_packages() {
  echo ""
  echo "In order to prevent errors and run $UPNAME, we need to install some packages."
  echo " Using $PACKAGE_MANAGER to install..."
  sudo $PACKAGE_MANAGER install $INSTALLER_NEEDED_REQUIREMENTS
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

install_symlink() {
  if [ $PYSYMLINK == true ]; then
      echo ""
      echo "Creating symlink for easy execution..."

      sudo rm -v $LINKTO/$TERMNAME
      sudo ln -sv $INSTALLPATH/main.py $LINKTO/$TERMNAME
  fi
}

install_add_startup() {
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

install_set_icon() {
  echo ""
  echo "Setting icons..."
  sudo cp -vf $INSTALLPATH/bin/$ICON.svg $INSTALLPATH/icon.svg && echo "Icon set as $ICON."
}

install_set_python_script() {
  echo ""
  echo "Setting scripts..."
  sudo sed -i "s|/path/to/bing-desktop-wallpaper-changer|$INSTALLPATH|g" "$INSTALLPATH/main.py"
  sudo sed -i "s|replace with the actual path to the bing-desktop-wallpaper-changer folder|Replaced to $INSTALLPATH by $INSTALLER_FULL_NAME|g" "$INSTALLPATH/main.py"
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
  install_symlink
  install_add_startup
  install_set_icon
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
    --opensource-license)
    info_opensource_license
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
      echo "- Hello, Developer $USER on HOSt $HOSTNAME -"
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
