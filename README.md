# bing-desktop-wallpaper-changer
Automatically changes desktop wallpaper to Bing Photo of the Day by www.bing.com

## Synopsis
Python Script for automatically changing the Desktop wallpaper to Bing Photo of the day. The script runs automatically at the startup.

## Installation
Clone/download project. Open terminal in the root folder of the project
1. Type in either of the two commands
    * Recommended
      ```shell
      pip install -r requirements.txt
      ```
    * Or install them individually
        ```shell
        sudo apt-get install python-bs4
        ```
        ```shell
        sudo apt-get install python-lxml
        ```
2. Then add the script as a startup application. Type in terminal
    ```shell
    gnome-session-properties
    ```
    then add a startup program as:
    ```
    Name: BingWallpaperChanger
    Command: python /path/to/main.py
    Comment: Automatically changes desktop wallpaper!
    ```

## Dependencies
* [BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup/)
* [lxml](http://lxml.de/)

## Author
Utkarsh Gupta - A beginner experimenting with Python, ignore any code formatting mistakes or so. Improvements to the code awaited.

## License
[MIT license](http://opensource.org/licenses/mit-license.php).
