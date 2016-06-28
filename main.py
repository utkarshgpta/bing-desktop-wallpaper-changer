#!/usr/bin/python
#-*- coding: utf-8 -*-

import os
import urllib2
import urllib
from bs4 import BeautifulSoup

BingXML_URL = "http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US"
page = urllib2.urlopen(BingXML_URL)
BingXML = BeautifulSoup(page, "lxml")
