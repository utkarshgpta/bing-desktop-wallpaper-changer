#!/bin/bash
# Bing-Desktop-Wallpaper-Changer Installer
# Script Copyright (C) 2017~  NKS (nks15)

NAME=bing-desktop-wallpaper-changer
UPNAME=Bing-Desktop-Wallpaper-Changer
TERMNAME=bingwallpaper
LINKTO=/usr/bin
AUTOSTART=$HOME/.config/autostart

echo ""
echo "$UPNAME Installer v1.0"
echo "Fully automated $UPNAME installation and configuration!"
echo ""
echo ""

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
echo -n "  Create symlink for easy execution in ex) Terminal (y/n)? : "
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

echo ""
echo "* Installing..."
echo ""

echo "We need Superuser permission to continue and install things..."
echo "I promise, I will never use Superuser permissions to do bad things!"
sudo echo " you are $(whoami)"
# TODO: Add a Easter Egg here

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

if [ $PYSYMLINK == true ]; then
    echo ""
    echo "Creating symlink for easy execution..."

    # sudo rm $LINKTO/$TERMNAME >> /dev/null * NOT NEEDED
    sudo ln -s $INSTALLPATH/main.py $LINKTO/$TERMNAME
    echo "$(ls $INSTALLPATH/main.py) symlinked in $(ls $LINKTO/$TERMNAME)"
fi

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

echo ""
echo "Setting icons..."
echo "Icon set as $ICON."
sudo cp -vf $INSTALLPATH/bin/$ICON.svg $INSTALLPATH/icon.svg

echo ""
echo "Setting python script..."
sed -i "s|/path/to/bing-desktop-wallpaper-changer|$INSTALLPATH|g" "$INSTALLPATH/main.py"
sed -i "s|replace with the actual path to the bing-desktop-wallpaper-changer folder|replaced to $INSTALLPATH by $UPNAME Installer|g" "$INSTALLPATH/main.py"

echo ""
echo "Executing $NAME..."
if [ $PYSYMLINK == true ]; then
    python $LINKTO/$TERMNAME
else
    python $INSTALLPATH/main.py
fi

echo ""
echo ""
echo "* Finished!!"
echo ""
