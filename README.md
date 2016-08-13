# bing-desktop-wallpaper-changer
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

## Installation

Clone/download project (or just the main.py file)

#### Autostart With gnome-session-properties
Then add the script as a startup application. Type in terminal

```shell
gnome-session-properties
```

then add a startup program as:
```plaintext
Name: BingWallpaperChanger
Command: python /path/to/main.py
Comment: Automatically changes desktop wallpaper!
```

![gnome-session-properties](startup.png "gnome-session-properties")

#### Autostart with ~/.config/autostart
If you run gnome 3 from Fedora, you have to create the file

/home/[user]/.config/autostart/bing-desktop-wallpaper-changer.desktop

the file contents look like:


```ini
[Desktop Entry]
Type=Application
Terminal=false
Exec=python /path/to/bing-desktop-wallpaper-changer/main.py
Name=Bing Desktop Wallpaper Changer
```

Replace [user] with your actual user name and /path/to/ with your actual
parent directory for the bing-desktop-wallpaper-changer directory.

#### Start with timer

A more elegant way to setup this script is using systemd.timer or cron job.
Since Bing only change their photo of the day every 24 hours, I will be optimize if you set up a timer unit to run exactly at the time new photo becomes available. To do that, go to `~/.config/systemd/user` and create two files:

`bing.service`
```ini
[Unit]
Description=Bing desktop wallpaper changer

[Service]
ExecStart=/path/to/main.py
```

`bing.timer`
```ini
[Unit]
Description=Bing desktop wallpaper changer

[Timer]
OnBootSec=20
OnUnitActiveSec=1d
OnCalendar=*-*-* 15:00:00
Persistent=true

[Install]
WantedBy=timers.target
```
Those two files must have the same name, differ only in the extension part (.service vs .timer). The `bing.service` file contain t he `ExecStart` option which specify the comman to execute, replace it to suit your installation.
`bing.timer` file will specify when would `bing.service` be executed. In the example above the service will run if either of those 3 conditions are met:

1. It's 20 seconds after the system boot up, specified by option `OnBootSec=20`, you can increase this number  to your liking.
2. It's 24 hours since the last time the service run, specified by option `OnUnitActiveSec=1d`
3. It's 3:00pm, specified by option `OnCalendar=*-*-* 15:00:00`, which is around the time bing change their photo in my local time. 
You can edit, add or remove thos conditon to your liking. If you are not using systemd you could use any scheduler for the task, like cron for example.

Afer finish editing those file, activate the service with the following command
```shell
systemctl --user enable bing.timer
systemctl --user start bing.timer
```


## Limit the size of all downloaded wallpapers
The application by default keep 100MiB worth of wallpapers, old wallpaper will be delete upon preserve this disk space constraint. To raise limit, edit config file 
```
~/.config/bing-desktop-wallpaper-changer/config.ini
```
and set option 
```
dir_max_size
```
to your liking. set it to zero or nonegative will keep an unlimit amount of downloaded wallpaper


## To do
- [x] Set the wallpaper according to the current screen size.
- [x] Support for dual monitors
- [x] Added as a Debian package in another branch
- [x] Store the details about the previous wallpapers (viz. date, filename, brief description) in an XML file so that the user can see that later too.
- [x] Permitting a limited number of wallpapers to be stored in the directory (disk space constraints)

*Any other suggestions welcome!*

## Author
Utkarsh Gupta and [Contributors](https://github.com/UtkarshGpta/bing-desktop-wallpaper-changer/network/members)

## License
[MIT license](http://opensource.org/licenses/mit-license.php).
