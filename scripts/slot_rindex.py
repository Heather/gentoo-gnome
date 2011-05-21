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

import sys
import os
import os.path as osp

import portage
from portage.xml.metadata import MetaDataXML

portdb = portage.portdb
portdb.porttrees = [portage.settings['PORTDIR']]
PORTDIR = portage.settings['PORTDIR']
DEPVARS = ['RDEPEND', 'PDEPEND', 'DEPEND']

#####################
### Configuration ###
#####################
if len(sys.argv) < 2:
    print "Usage: %s <cat/pkg>" % sys.argv[0]
    sys.exit(1)

KEY = sys.argv[1]
PORTAGE_ONLY = False
IGNORE_OBSOLETE = False
if os.environ.has_key('PORTAGE_ONLY'):
    PORTAGE_ONLY = os.environ['PORTAGE_ONLY']
if os.environ.has_key('IGNORE_OBSOLETE'):
    IGNORE_OBSOLETE = os.environ['IGNORE_OBSOLETE']

########################
### Output Functions ###
########################
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
    print "-------------------------------"
    print "All packages:"
    print "-------------------------------"
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

    print "-------------------------------"
    print "Herd packages:"
    print "-------------------------------"
    for (herd, pkgs) in pkg_herds.iteritems():
        print 'Herd: %s' % herd
        for pkg in pkgs:
            print '\t%s' % pkg

    print "-------------------------------"
    print "Maintainer packages:"
    print "-------------------------------"
    for (maint, pkgs) in pkg_maints.iteritems():
        print 'Maintainer: %s' % maint
        for pkg in pkgs:
            print '\t%s' % pkg

#############################
### Portage API Functions ###
#############################
def get_deps_both(cpv, depvars=DEPVARS):
    """
    Parses the dependency variables listed in depvars for cpv

    returns (set(dep_cps), set(dep_strs))
    """
    dep_cps = set()
    dep_strs = set()
    raw_deps = []
    try:
        raw_deps = portdb.aux_get(cpv, depvars)[0].split()
    except KeyError:
        return (dep_cps, dep_strs)
    for dep in portage.dep.use_reduce(' '.join(raw_deps),
                                      matchall=True, flat=True):
        # Ignore blockers, etc
        if portage.isvalidatom(dep):
            dep_strs.add(dep)
            dep_cps.add(portage.dep.dep_getkey(dep))
    return (dep_cps, dep_strs)

def get_dep_slot(dep):
    """
    If the dep atom contains a slot, return that
    If the dep atom doesn't contain a slot, but is of the =cat/pkg-ver* type,
    check which slots each satisfied cpv has, and return that if they're all the
    same; return None if they're different
    """
    # FIXME: Use our own portdb so that we match atoms outside of PORTDIR too
    slot = portage.dep.dep_getslot(dep)
    if slot or not dep.startswith('='):
        return slot
    cp = portage.dep.dep_getkey(dep)
    cpvrs = portage.dep.match_from_list(dep, portdb.xmatch('match-all', cp))
    for cpvr in cpvrs:
        my_slot = portdb.aux_get(cpvr, ['SLOT'])[0]
        if slot and my_slot != slot:
            # omg, one of the slots is different
            return None
        slot = my_slot
    return slot

def get_revdeps_rindex(key):
    """
    Given a key, returns a reverse-dependency list of that key using the tinderbox rindex
    list will be a sorted list of unique cpvs
    """
    import urllib2
    RINDEX = "http://tinderbox.dev.gentoo.org/misc/rindex"
    revdeps = set()
    try:
        rdeps_raw = urllib2.urlopen('/'.join([RINDEX, key])).read().split()
    except urllib2.HTTPError, e:
        if e.getcode() == 404:
            return revdeps
        raise
    for i in rdeps_raw:
        cpv = i.split(':')[0]
        if portage.isvalidatom('='+cpv):
            revdeps.add(cpv)
    revdeps = list(revdeps)
    revdeps.sort()
    return revdeps

def get_revdeps_portage(key):
    """
    Given a key, returns a reverse-dependency list of that key using portage API
    list will be a sorted list of unique cpvs
    """
    revdeps = set()
    for cp in portdb.cp_all():
        cpvrs = portdb.xmatch('match-all', cp)
        for cpvr in cpvrs:
            if key in get_deps_both(cpvr)[0]:
                revdeps.add(cpvr)
    revdeps = list(revdeps)
    revdeps.sort()
    return revdeps

###################
### Actual Work ###
###################
slot_rdeps = {}
revdeps = []
if PORTAGE_ONLY:
    revdeps = get_revdeps_portage(KEY)
else:
    revdeps = get_revdeps_rindex(KEY)

for rdep in revdeps:
    if IGNORE_OBSOLETE:
        from obsolete_ebuilds import get_obsolete
        if rdep in get_obsolete(portage.pkgsplit(rdep)[0]):
            continue
    (cps, deps) = get_deps_both(rdep)
    if KEY not in cps:
        continue
    for dep in deps:
        if dep.find(KEY) == -1:
            continue
        slot = get_dep_slot(dep)
        if not slot_rdeps.has_key(slot):
            slot_rdeps[slot] = []
        slot_rdeps[slot].append(rdep)

rdeps_with_slot(slot_rdeps)
