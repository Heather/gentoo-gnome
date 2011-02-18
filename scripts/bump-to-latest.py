#!/usr/bin/env python2
# vim: set sw=4 sts=4 et :
# Author(s): Nirbheek Chauhan <nirbheek@gentoo.org>
#
# This script does the following:
#
# * For each package in gnome overlay
# * Parse gentoo-bumpchecker output to get current/latest versions
#   - Skip if not in gentoo-bumpchecker output
# * Check if current version is in the overlay
#   - Check if latest version != current version
# * If it is, bump to latest version, manifest, extract old/new tarballs
# * If not, skip
#
# Created to automate the menial tasks associated with bumping
#
# BUGS:
# * Has problems with masked packages in overlay (due to gentoo-bumpchecker)
# TODO:
# * Ignores all packages without an existing version in gnome overlay

import os, subprocess, shutil
import portage
from portage.output import *

# gentoo-bumpchecker output file
BCO = "SET THIS TO YOUR gentoo-bumpchecker output file path"
PORTDB = portage.db['/']['porttree'].dbapi
GNOME_OVERLAY = PORTDB.getRepositoryPath('gnome')
DISTDIR = portage.settings['DISTDIR']
PORTDIR = portage.settings['PORTDIR']

os.chdir(GNOME_OVERLAY)

def versions(pkg):
    """Return current version, official version, latest version of given pkg"""
    process = subprocess.Popen("grep -A 3 -we %s %s" % (pkg, BCO), shell=True,
                               stdout=subprocess.PIPE)
    process.wait()
    output = process.stdout.read()
    return output.replace('<td>', '').replace('</td>', '')

# NOTE: Not compatible with EAPI=2 distfile renaming
def fetch_distfile(cpv):
    """Manually fetch the distfile for an ebuild cpv"""
    distfile = gnome_distfile(cpv, fulluri=True)
    distfile = distfile.replace("mirror://", "http://ftp.gnome.org/pub/")
    subprocess.check_call("wget '%s' -P '%s'" % (distfile, DISTDIR), shell=True)
    
# NOTE: Not compatible with EAPI=2 distfile renaming
def gnome_distfile(cpv, fulluri=False):
    """Return gnome tarball name from ebuild cpv"""
    distfiles = portage.portdb.aux_get(cpv, ['SRC_URI'])[0].split()
    for distfile in distfiles:
        if distfile.find('mirror://gnome') != -1:
            if fulluri:
                return distfile
            else:
                return os.path.basename(distfile)

def match_cpv_to_ebuild(categ, pkg, ver):
    """Matches cpv to an ebuild, and returns a correspondinglyadjusted version.
    Returns (None, None) if no matching ebuild found"""
    pv = "%s-%s" % (pkg, ver)
    overlay_path = "%s/%s/%s" % (GNOME_OVERLAY, categ, pkg)
    overlay_ebuilds = [i for i in os.listdir(overlay_path) if i.endswith('.ebuild')]

    for ebuild in overlay_ebuilds:
        if ebuild.find(pv) != -1:
            ebuild_path = "%s/%s" % (overlay_path, ebuild)
            parts = portage.catpkgsplit(ebuild.split('.ebuild')[0])[-2:]
            version = "%s-%s" % (parts[-2], parts[-1])
            return (ebuild_path, version.replace('-r0', ''))
    return (None, None)
# Portage section, disabled for now.
#    portdir_path = "%s/%s/%s" % (PORTDIR, categ, pkg)
#    portdir_ebuilds = os.listdir(portdir_path)
#    for ebuild in portdir_ebuilds:
#        if ebuild.find(pv) != -1:
#            return "%s/%s" % (portdir_path, ebuild)

dirs = os.listdir('.')
categs = []
for i in dirs:
    if os.path.isdir(i) and i.find('-') != -1:
        categs.append(i)

for categ in categs:
    for pkg in os.listdir(categ):
        # Get versions from bumpchecker output
        vers = versions(pkg).split()
        if not vers:
            continue
        cv = vers[1] # Current Version
        lv = vers[3] # Latest Version
        if cv >= lv:
            continue
        (ce, cv) = match_cpv_to_ebuild(categ, pkg, cv)
        le = "%s/%s/%s-%s.ebuild" % (categ, pkg, pkg, lv)
        if not ce:
            # No matching ebuild found in overlay
            continue
        ### Start Work ###
        # Distfile for current ebuild
        cd = gnome_distfile('%s/%s-%s' % (categ, pkg, cv))
        # If distfile for current ebuild does not exist
        if not os.path.exists("%s/%s" % (DISTDIR, cd)):
            print yellow("%s/%s not found, forcing re-fetch.." % (DISTDIR, cd))
            # Manually fetch it
            fetch_distfile('%s/%s-%s' % (categ, pkg, cv))
        print green("Move ") + "%s -> %s" % (ce, le)
        shutil.move(ce, le)
        print green("Manifest ") + le
        try:
            subprocess.check_call("ebuild %s manifest" % le, shell=True)
        except subprocess.CalledProcessError:
            print red("%s failed to Manifest! Skipping..." % le)
            continue
        # Distfile for latest ebuild
        ld = gnome_distfile('%s/%s-%s' % (categ, pkg, lv))
        print green("Extract ") + "%s/%s" % (DISTDIR, cd)
        # Extract old tarball
        subprocess.check_call("tar xf %s/%s -C %s/%s" % (DISTDIR, cd, categ, pkg),
                              shell=True)
        print green("Extract ") + "%s/%s" % (DISTDIR, ld)
        # Extract new tarball
        subprocess.check_call("tar xf %s/%s -C %s/%s" % (DISTDIR, ld, categ, pkg),
                              shell=True)
