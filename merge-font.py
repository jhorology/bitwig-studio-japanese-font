#!/usr/bin/env fontforge -lang=py -script
# -*- coding: utf-8 -*-

import fontforge
import sys
 
# command line arguments
original = sys.argv[1]
cjk = sys.argv[2]
dist = sys.argv[3]

font = fontforge.open(original)
font.mergeFonts(cjk)
font.generate(dist)
