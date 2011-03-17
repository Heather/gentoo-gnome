#!/usr/bin/env python2
# vim: set sts=4 sw=4 et :
#
# Author(s): Nirbheek Chauhan
# License: MIT
#
# A small script which sorts the revdeps of a given library according to
# which slot of the given library they depend on. Uses the tinderbox rindex for
# speed, because of which results may be out of date.
#
# Currently prints out a list of revdeps which *don't* use a slot in the
# dependency atom containing the given library
#
# TODO: Add a slower portage-only mode which calculates the required rindex
#

import sys
import urllib2
import os.path as osp

import portage
from portage.xml.metadata import MetaDataXML

if len(sys.argv) < 2:
    print "Usage: %s <cat/pkg>" % sys.argv[0]
    sys.exit(1)

portage.portdb.porttrees = [portage.settings['PORTDIR']]
PORTDIR = portage.settings['PORTDIR']
RINDEX = "http://tinderbox.dev.gentoo.org/misc/rindex"
DEPSTR = ['RDEPEND', 'PDEPEND', 'DEPEND']
KEY = sys.argv[1]

def get_herds():
    return osp.join(PORTDIR, 'metadata', 'herds.xml')

def get_md_path(cpv):
    """
    x11-libs/gtk+-2.22.0-r1 -> <portdir>/x11-libs/gtk+/metadata.xml
    """
    path = osp.join(*portage.catpkgsplit(cpv)[0:2])
    return osp.join(PORTDIR, path, 'metadata.xml')

def rdeps_with_slot(slot_rdeps, slot=None):
    """
    Prints a list of rev-deps which depend on the specified package and slot
    """
    pkg_maints = {}
    pkg_herds = {}
    if not slot_rdeps.has_key(slot):
        # No rdeps using the given slot
        return
    print "All packages:"
    for pkg in slot_rdeps[slot]:
        pkg_md = MetaDataXML(get_md_path(pkg), get_herds())
        for herd in pkg_md.herds():
            if not pkg_herds.has_key(herd):
                pkg_herds[herd] = []
            pkg_herds[herd].append(pkg)
        for maint in pkg_md.maintainers():
            if not pkg_maints.has_key(maint.email):
                pkg_maints[maint.email] = []
            pkg_maints[maint.email].append(pkg)
        print '\t%s\therds: ' % pkg,
        for i in pkg_md.herds():
            print '%s' % i,
        print '\tmaintainers: ',
        for i in pkg_md.maintainers():
            print '%s' % i.email,
        print

    print "Herd packages:"
    for (herd, pkgs) in pkg_herds.iteritems():
        print 'Herd: %s' % herd
        for pkg in pkgs:
            print '\t%s' % pkg

    print "Maintainer packages:"
    for (maint, pkgs) in pkg_maints.iteritems():
        print 'Maintainer: %s' % maint
        for pkg in pkgs:
            print '\t%s' % pkg


vrdeps = urllib2.urlopen('/'.join([RINDEX, KEY])).read().split()
rdeps = []
for i in vrdeps:
    rdeps.append(i.split(':')[0])

slot_rdeps = {}
failed_rdeps = []
for rdep in rdeps:
    rdep = rdep.split(':')[0]
    if not portage.isvalidatom('='+rdep):
        print 'Invalid atom: ' + rdep
        continue
    try:
        temp = portage.portdb.aux_get(rdep, DEPSTR)[0].split()
    except KeyError:
        failed_rdeps.append(rdep)
        continue
    for dep in temp:
        # Ignore ||, (, ), etc.
        if not portage.isvalidatom(dep):
            continue
        # Categorize the dep into the slot it uses
        if portage.dep.dep_getkey(dep) == KEY:
            slot = portage.dep.dep_getslot(dep)
            if not slot_rdeps.has_key(slot):
                # We use a set here because atoms often get repeated
                slot_rdeps[slot] = set()
            slot_rdeps[slot].add(rdep)

# Convert back to list, and sort the atoms
for slot in slot_rdeps.keys():
    slot_rdeps[slot] = list(slot_rdeps[slot])
    slot_rdeps[slot].sort()

if failed_rdeps:
    print 'Failed: ' + str(failed_rdeps)

rdeps_with_slot(slot_rdeps)
