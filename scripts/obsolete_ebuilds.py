#!/usr/bin/env python2
# vim: set sts=4 sw=4 et tw=0 :
#
# Author(s): Nirbheek Chauhan <nirbheek@gentoo.org>
# License: MIT
#
# Package to figure out which stable or unstable ebuilds aren't needed
# based on the current keywords
#

import os
import sys

import portage

def usage():
    print "Usage: %s <cpv>" % sys.argv[0]

###############
## Constants ##
###############
PORTDIR = portage.settings["PORTDIR"]
portdb = portage.portdb
settings = portage.settings
portdb.porttrees = [PORTDIR]
STABLE_ARCHES = tuple(settings['PORTAGE_ARCHLIST'].split())
UNSTABLE_ARCHES = tuple(map(lambda x: '~'+x, STABLE_ARCHES))
ALL_ARCHES = STABLE_ARCHES+UNSTABLE_ARCHES

######################
## Define Functions ##
######################
def convert_kw(kw):
    "Convert ~arch to arch and leave arch alone"
    if kw.startswith('~'):
        return kw[1:]
    return kw

def get_kws(cpv, arches=ALL_ARCHES):
    """
    Returns an array of KEYWORDS matching 'arches'
    """
    kws = []
    for kw in portdb.aux_get(cpv, ['KEYWORDS'])[0].split():
        if kw in arches:
            kws.append(kw)
    return kws

def cmp_kws(new_kws, old_kws):
    """
    old_kws and new_kws must be sets
    Returns:
     False if new_kws is the same as or worse than old_kws
       Ex: (a, b)       vs (a, b, c) or
           (a, b, c)    vs (a, b, c) or
           (a, b, ~c)   vs (a, b, c), etc
     True if new_kws is better than old_kws
       Ex: (a, b, c)    vs (a, b) or
           (a, b, c)    vs (a, b, ~c), etc
       OR if new_kws is neither better nor worse than old_kws
       Ex: (a, b, c)    vs (a, c, d) or
           (a, b, ~d)   vs (a, c, d), etc
    """
    if not old_kws:
        return True
    if not new_kws:
        # No keywords
        return False
    if new_kws.issubset(old_kws):
        return False
    # If there are some new keywords in new_kws, and they aren't ~arch versions of the kws in old_kws
    if set(map(convert_kw, new_kws.difference(old_kws))).difference(old_kws):
        return True
    return False


def get_obsolete(cp):
    """
    @param cp: cat/pkg atom
    @type cp: string
    @param check_kws: Which keywords to check for obsolete ebuilds, both/stable/unstable
    @type check_kws: String
    """
    cpvs = portdb.xmatch('match-all', cp)
    obsolete_cpvs = []
    not_pmasked = []
    slot_cpvs = {}

    # This is copied from portage/dbapi/porttree.py:visible()
    # Ignore PORTDIR package.masked cpvs
    for cpv in cpvs:
        try:
            metadata = {'SLOT': portdb.aux_get(cpv, ['SLOT'])[0]}
        except KeyError:
            # masked by corruption
            continue
        if settings._getMaskAtom(cpv, metadata):
            continue
        # We skip the profile check because we don't care about that
        not_pmasked.append(cpv)
    # We start with the latest cpvs first so that we never mark newer ebuilds as obsolete
    not_pmasked.reverse()
    
    # Generate a slot-sorted hashtable for cpvs
    for cpv in not_pmasked:
        slot = portdb.aux_get(cpv, ['SLOT'])[0]
        if not slot_cpvs.has_key(slot):
            slot_cpvs[slot] = []
        slot_cpvs[slot].append(cpv)

    # Consider each slot separately for obsolete-detection
    for (slot, cpvs) in slot_cpvs.iteritems():
        all_kws = set()
        for cpv in cpvs:
            kws = set(get_kws(cpv, arches=ALL_ARCHES))
            if cmp_kws(kws, all_kws):
                # Keywords list is unique or better, so add it to the list
                all_kws.update(kws)
            else:
                # Same or worse keywords (unstable and stable) => can be punted
                obsolete_cpvs.append(cpv)
    return obsolete_cpvs

if __name__ == "__main__":
    if len(sys.argv) < 2:
        usage()
        sys.exit(1)
    if sys.argv[1] == '.':
        sys.argv[1] = '/'.join((os.path.basename(os.path.dirname(os.getcwd())), os.path.basename(os.getcwd())))
    for i in get_obsolete(sys.argv[1]):
        print portage.catsplit(i)[-1]+'.ebuild',
