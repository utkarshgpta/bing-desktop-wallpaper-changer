# Bing-Desktop-Wallpaper-Changer Shell Script Installer
**Fully automated Bing-Desktop-Wallpaper-Changer installation and configuration!**

**No need to add the script to your Startup list or edit main.py or copy paste it or etc..**

**The Installer does everything for you!**


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

## Installation

1 Clone/download project

2 Open a terminal and enter:
```
chmod +x install.sh
./install.sh
```
3 DONE!

## To do
- [ ] Ask user about: Schedule with crontab, Limit the size of all downloaded wallpapers, Start with timer
- [ ] Pull request and Add this to the official repo

*Any other suggestions welcome!*

## Author
Utkarsh Gupta, nks15 and [Contributors](https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer/network/members)

## License
[MIT license](http://opensource.org/licenses/mit-license.php).
