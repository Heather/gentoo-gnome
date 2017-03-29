#!/usr/bin/env python

#TODO:
#
# * ignore list

__author__ = 'cynede@gentoo.org'

import os
import sys
import glob
import re
import shutil

def regex_key(key):
  """Traditional, regular-expression-based nat-sort key."""
  convert = lambda text: int(text) if text.isdigit() else text.lower()
  return [convert(c) for c in re.split('([0-9]+)', key)]

def nat_cmp(a, b):
  return (regex_key(a) > regex_key(b))

if len(sys.argv) < 2:
  print("pass overlay path to compare with as first argument")
  sys.exit()
overlay = sys.argv[1]
print("checking updated ebuilds...")
for root, dirs, files in os.walk('.', topdown=True, followlinks=False):
  dirs[:] = list(filter(lambda x: not x in [".git", "profiles", "metadata", "files"], dirs))
  if dirs and root != ".":
    for dir in dirs:
      realpath = os.path.join(root, dir)
      fullpath = realpath[2:]
      chkpath = os.path.join(overlay, fullpath)
      if os.path.isdir(chkpath):
        efullpath = list(filter(lambda x: not x.endswith("-9999.ebuild"), glob.glob(os.path.join(realpath, "*.ebuild"))))
        echkpath = list(filter(lambda x: not x.endswith("-9999.ebuild"), glob.glob(os.path.join(chkpath, "*.ebuild"))))
        if efullpath and echkpath:
          enamesf = map(lambda x: os.path.splitext(os.path.basename(x))[0], efullpath)
          enamesc = map(lambda x: os.path.splitext(os.path.basename(x))[0], echkpath)
          maxf = max(enamesf)
          maxc = max(enamesc)
          if nat_cmp(maxc, maxf):
            print("%s > %s" % (maxc, maxf))
            print("removing %s" % realpath)
            shutil.rmtree(realpath)
print("checking for empty root folders...")
for chdir in os.listdir('.'):
  if os.path.isdir(chdir):
    if not chdir in [".git", "profiles", "metadata", "files"]:
      if os.listdir(chdir) == []:
        print("removing %s" % chdir)
        os.rmdir(chdir)

