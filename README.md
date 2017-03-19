# Bing Desktop Wallpaper Changer
Automatically downloads and changes desktop wallpaper to Bing Photo of the Day.

## Synopsis
Python Script for automatically downloading and changing the desktop wallpaper to Bing Photo of the day. The script runs automatically at the startup and works on GNU/Linux with Gnome. Works perfectly on Ubuntu 16.10.

## What does it do?
It grabs images exactly the same way *Microsoft* uses to put it up on its page - using **XML/RSS/JSON**. You can't scrape the website directly. After searching on the internet for long I found out the link - *http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US*

Here we can get data in any of the formats but substituting the value of **format=[value]** in the link.

**idx** denotes the *day before the current day*. idx=0 means current day, idx=1 means yesterday and so on.
**n** is an integer denoting the *number of days before the day denoted by idx*. It grabs data about all the n number of images.
**mkt** denotes the *area*. The script will try to match your locale to one of the supported Bing Market areas, falling back to 'en-US' if it fails to do so. You can also force a particular market area (see list of valid markets in https://msdn.microsoft.com/en-us/library/dd251064.aspx) in the config file:

```
~/.config/bing-desktop-wallpaper-changer/config.ini
```

Example:

```ini
[market]
# If you want to override the current Bing market dectection,
# set your preferred market here. For a list of markets, see
# https://msdn.microsoft.com/en-us/library/dd251064.aspx
area = 'bg-BG'
```

To force your area to be 'bg-BG' (Bulgarian - Bulgaria).

All the wallpapers are stored in '**/home/[user]/Pictures/BingWallpapers/**'

## Bing-Desktop-Wallpaper-Changer Installer
Fully automated Bing-Desktop-Wallpaper-Changer installation and configuration!
No need to add the script to your Startup list or edit main.py or copy paste it or etc..
The Installer does everything for you!

### Using the Installer
Starting with Installer version 2.0, the Installer works like a normal linux binary commands (for example, ls, cd, etc..)

Note that the Installer can request root permissions(sudo) for doing some tasks

### Preparing & Help

When you first run the Installer, you need to prepare:

1 Clone/download project

2 Move into the downloaded project's directory

3 Open a terminal and enter:
```
chmod +x installer.sh
./installer.sh --help
```
4 Help screen will pop up on your Terminal - You can see the Installer's all Usages and Arguments

### Using

*INFO: Complete *Prepare & Help* before you use the Installer!*


To install, use:
```
./installer.sh --install
```
and to uninstall, use:
```
./installer.sh --uninstall
```

Other usages is listed below:
```
Usage: installer.sh [OPTION]...
       installer.sh [OPTION=*]...

 --help       displays help about installer and tasks
 --version    displays the installer version
 --license    displays LICENSE
 --readme     displays README.md
 --detect-previous-install    detects previous Bing-Desktop-Wallpaper-Changer installation
 --install    installs Bing-Desktop-Wallpaper-Changer
 --uninstall  uninstalls Bing-Desktop-Wallpaper-Changer
 --update     updates Bing-Desktop-Wallpaper-Changer (needs git)
 --execute    runs $UPNAME

 For developers:
 --enable-dev-mode    enables Developer Mode
 --disable-dev-mode   disables Developer Mode
 --run-function-or-command=*    runs internal functions or shell commands

 Note that Developer Mode is disabled automatically when Installer restarts (because of security reasons),
 those who wish to run developer tasks will always have to put --enable-dev-mode in front of OPTION.
 For example, installer.sh --enable-dev-mode [DEVELOPER_OPTION/TASKS]

 To directly run internal functions or shell commands, first you need to enable Dev Mode and use --run-function-or-command.
 For example, installer.sh --enable-dev-mode --run-function-or-command=[YOUR COMMAND]

 For more information, please visit:
 GitHub: <https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer>

 And you know what? #This_Installer_can_moo!
```

## To do
- [ ] When installing, Ask user about : Schedule with crontab, Limit the size of all downloaded wallpapers, Start with timer

*Any other suggestions welcome!*

## Author
Utkarsh Gupta and [Contributors](https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer/network/members)

## License
[MIT license](http://opensource.org/licenses/mit-license.php).
