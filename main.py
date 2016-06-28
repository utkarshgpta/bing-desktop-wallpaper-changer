#!/usr/bin/python
#-*- coding: utf-8 -*-

import os
import urllib2
import urllib
from bs4 import BeautifulSoup
import getpass

BingXML_URL = "http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US"
page = urllib2.urlopen(BingXML_URL)
BingXML = BeautifulSoup(page, "lxml")

Images = BingXML.find_all('image')
ImageURL = "https://www.bing.com" + Images[0].url.text
ImageName = Images[0].startdate.text+".jpg"

username = getpass.getuser()
path = '/home/' + username + '/Pictures/BingWallpapers/'
if not os.path.exists(path):
	os.makedirs(path)
	print "New Directory Created"
os.chdir(path)
if not os.path.isfile(ImageName):
	urllib.urlretrieve(ImageURL, ImageName)
	os.system('notify-send "'+'Bing Wallpaper updated successfully'+'" "'+ Images[0].copyright.text.encode('utf-8') +'"')
	os.system("gsettings set org.gnome.desktop.background picture-uri file:" + path + ImageName )
else:
	os._exit(1)
