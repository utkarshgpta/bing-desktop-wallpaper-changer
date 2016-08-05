#!/usr/bin/python
#-*- coding: utf-8 -*-

import locale
import os
import re
import sys
import urllib
import urllib2

from bs4 import BeautifulSoup

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Notify', '0.7')
from gi.repository import Gio
from gi.repository import Gtk
from gi.repository import Notify


class BackgroundChanger():
    SCHEMA = 'org.gnome.desktop.background'
    KEY = 'picture-uri'

    def change_background(self, filename):
        gsettings = Gio.Settings.new(self.SCHEMA)
        gsettings.set_string(self.KEY, "file://" + filename)
        gsettings.apply()


def get_valid_bing_markets():
    """
    Find valid Bing markets for area auto detection.

    :see: https://msdn.microsoft.com/en-us/library/dd251064.aspx
    :return: List with valid Bing markets (list looks like a list of locales).
    """
    url = 'https://msdn.microsoft.com/en-us/library/dd251064.aspx'
    page = urllib2.urlopen(url)
    page_xml = BeautifulSoup(page, 'lxml')
    # Look in the table data
    market = page_xml.find_all('td')
    market_locales = [el[1].text.strip() for el in enumerate(market) if
                      el[0] % 2 == 0]
    return market_locales


def get_bing_xml():
    """
    Get BingXML file which contains the URL of the Bing Photo of the day.

    :return: URL with the Bing Photo of the day.
    """
    # idx = Number days previous the present day.
    # 0 means today, 1 means yesterday
    # n = Number of images previous the day given by idx
    # mkt = Bing Market Area, see get_valid_bing_markets.
    market = 'en-US'
    default_locale = locale.getdefaultlocale()[0]
    if default_locale in get_valid_bing_markets():
        market = default_locale
    return "http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=%s" % market


def get_screen_resolution_str():
    """
    Get a regexp like string with your current screen resolution.

    :return: String with your current screen resolution.
    """
    # Get appropriate screen resolution
    window = Gtk.Window()
    screen = window.get_screen()
    nmons = screen.get_n_monitors()
    if nmons == 1:
    	return r'%sx%s' % (screen.get_width(), screen.get_height())
    else:
    	maxw = 0
    	maxh = 0
    	for m in range(nmons):
    		mg = screen.get_monitor_geometry(m)
    		if mg.width > maxw or mg.height > maxw:
    			maxw = mg.width
    			maxh = mg.height
    	return r'%sx%s' % (maxw, maxh)


def get_image_metadata():
    """
    Get Bing wallpaper metadata.

    :return: XML tag object for the wallpaper image.
    """
    bing_xml_url = get_bing_xml()
    page = urllib2.urlopen(bing_xml_url)
    bing_xml = BeautifulSoup(page, "lxml")
    # For extracting complete URL of the image
    images = bing_xml.find_all('image')
    return images[0]


def get_image_url(metadata):
    """
    Get an appropriate Wallpaper URL based on your screen resolution.

    :param metadata: XML tag object with image metadata.
    :return: URL with Bing Wallpaper image.
    """
    base_image = metadata.url.text
    # Replace image resolution with the correct resolution
    # from your main monitor
    screen_size = get_screen_resolution_str()
    correct_resolution_image = re.sub(r'\d+x\d+', screen_size, base_image)
    return "https://www.bing.com" + correct_resolution_image


def init_dir(path):
    """
    Create directory if it doesn't exist.

    :param path: Path to a directory.
    """
    if not os.path.exists(path):
        os.makedirs(path)


def main():
    """
    Main application entry point.
    """
    app_name = 'Bing Desktop Wallpaper'
    Notify.init(app_name)
    exit_status = 0
    try:
        image_metadata = get_image_metadata()
        image_name = image_metadata.startdate.text + ".jpg"
        image_url = get_image_url(image_metadata)
        # Images saved to '/home/[user]/Pictures/BingWallpapers/'
        download_path = os.path.join(os.path.expanduser('~'), 'Pictures',
                                     'BingWallpapers')
        init_dir(download_path)
        image_path = os.path.join(download_path, image_name)

        if not os.path.isfile(image_path):
            urllib.urlretrieve(image_url, image_path)
            bg_changer = BackgroundChanger()
            bg_changer.change_background(image_path)
            summary = 'Bing Wallpaper updated successfully'
            body = image_metadata.copyright.text.encode('utf-8')
        else:
            summary = 'Bing Wallpaper unchanged'
            body = ('%s already exists in Wallpaper directory' %
                    image_metadata.copyright.text.encode('utf-8'))
    except Exception as err:
        summary = 'Error executing %s' % app_name
        body = err
        exit_status = 1

    app_notification = Notify.Notification.new(summary, body)
    app_notification.show()
    sys.exit(exit_status)

if __name__ == '__main__':
    main()
