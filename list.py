#!/usr/bin/env python

__author__ = 'cynede@gentoo.org'

import os
import sys
import glob

for root, dirs, files in os.walk('.', topdown=True, followlinks=False):
  dirs[:] = list(filter(lambda x: not x in [".git", "profiles", "metadata", "files"], dirs))
  if dirs and root != ".":
    for dir in dirs:
      realpath = os.path.join(root, dir)
      efullpath = list(filter(lambda x: not x.endswith("-9999.ebuild"), glob.glob(os.path.join(realpath, "*.ebuild"))))
      if efullpath:
        enamesf = map(lambda x: os.path.splitext(os.path.basename(x))[0], efullpath)
        for e in enamesf: print(e)

