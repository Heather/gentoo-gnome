#!/usr/bin/env python
# vim: set sw=4 sts=4 et :
# Author(s): Nirbheek Chauhan <nirbheek@gentoo.org>
#
# Given a category/package list, and (optionally) a new/old release number,
# generates a STABLEREQ list, or a KEYWORDREQ list.
#
# Toggle STABLE to control which type of list to generate.
#
# You can use test-data/package-list to test the script out.
# 
# TODO:
# * belongs_release() is a very primitive function, which means usage of old/new
#   release numbers gives misleading output
# * ispmasked() is quite broken. It only works if the atom in p.masked is the
#   same as the cpv in the argument
# * Only supports ebuilds in PORTDIR
# * Alignment of output is very bad
#

from __future__ import division
import os, sys
import portage

###############
## Constants ##
###############
#PORTDB = portage.db['/']['porttree'].dbapi
#GNOME_OVERLAY = PORTDB.getRepositoryPath('gnome')
PORTDIR = portage.settings['PORTDIR']
STABLE_ARCHES = ('alpha', 'amd64', 'arm', 'hppa', 'ia64', 'm68k', 'ppc',
        'ppc64', 's390', 'sh', 'sparc', 'x86')
UNSTABLE_ARCHES = ('~alpha', '~amd64', '~arm', '~hppa', '~ia64', 'm68k', '~ppc',
        '~ppc64', '~s390', '~sh', '~sparc', '~x86', '~x86-fbsd')

##############
## Settings ##
##############
DEBUG = False
STABLE = True # Check for stable keywords
OLD_REL = None
NEW_REL = None
try:
    CP_FILE = sys.argv[1] # File which has the cp list
except IndexError:
    print 'Usage: %s <file> [old_rel] [new_rel]' % sys.argv[0]
    print 'Where <file> is a file with a category/package list'
    print '  [old_rel] is an optional argument for specifying which release cycle'
    print '            to use to get the cpv which has the keyword we need'
    print '            i.e., which cpvs will we get the list of keywords from?'
    print '  [new_rel] is an optional argument for specifying which release cycle'
    print '            to use to get the latest cpv on which we want keywords'
    print '            i.e., which cpvs will go in the list?'
    sys.exit(0)
if len(sys.argv) > 2:
    OLD_REL = sys.argv[2]
    if len(sys.argv) > 3:
        NEW_REL = sys.argv[3]

######################
## Define Functions ##
######################
def flatten(list, sep=' '):
    "Given a list, returns a flat string separated by 'sep'"
    str = ''
    for i in list:
        str += i+sep
    return str[:-1] # There's an extra 'sep' at the end

def debug_print(string, debug=False):
    from portage.output import EOutput
    ewarn = EOutput().ewarn
    prefix = ''
    if debug:
        prefix = '(DEBUG) '
    ewarn('%s%s' % (prefix, string))

def belongs_release(cpv, release):
    "Check if the given cpv belongs to the given release"
    # FIXME: This failure function needs better logic
    return get_ver(cpv).startswith(release)

def get_ver(cpv):
    split = portage.catpkgsplit(cpv)
    return '%s-%s' % (split[2], split[3])

def get_pvs(cp, repo=PORTDIR):
    """
    Given a cp, find all pvs in portage
    
    afaik, there's no equivalent in the portage API
    """
    ct = portage.catsplit(cp)[0]
    fs = os.listdir('%s/%s' % (repo, cp))
    return [ct+'/'+i.replace('.ebuild', '') for i in fs if i.endswith('.ebuild')]

def ispmasked(cpv):
    """
    Check if a package atom is masked

    FIXME: Doesn't quite work yet. Need to manually parse p.mask or something.
    """
    portdb = portage.portdb
    db_keys = list(portdb._aux_cache_keys)
    metadata = dict(zip(db_keys, portdb.aux_get(cpv, db_keys)))
    if portage.settings._getMaskAtom(cpv, metadata):
        return True
    else:
        return False

def latest_kws(cp, old_rel=OLD_REL,
                   new_rel=NEW_REL,
                   stable=STABLE,
                   ignore_empty_kws=False):
    """
    Given a cp, find the latest cpv in old_rel that has keywords we need for
    STABLEREQ/KEYWORDREQ of the latest cpv which matches new_rel

    @stable: Generate keywords for STABLEREQ
    @ignore_empty_kws: Ignore cpvs with no keywords at all
    """
    arches = None
    best_old = ['', []]
    best_new = ['', []]
    cp_kws = []
    if stable:
        arches = STABLE_ARCHES
    else:
        arches = UNSTABLE_ARCHES
        
    ## Generate list of cpvs and keywords
    # Note: this list is unreliably ordered
    cpvs = get_pvs(cp)
    while len(cpvs) > 0:
        # We do this so that cp_kws is sorted in descending order of cpvs
        cpv = portage.best(cpvs)
        cpvs.remove(cpv)
        if ispmasked(cpv):
            # We always ignore p.masked cpvs
            continue
        # Start populating the [cpv, [keywords]] list
        cpv_kws = []
        for keyword in portage.portdb.aux_get(cpv, ['KEYWORDS'])[0].split():
            if keyword in arches: cpv_kws.append(keyword)
        # If the cpv has no keywords, completely skip it
        if ignore_empty_kws and not cpv_kws:
            continue
        cp_kws.append([cpv, cpv_kws])

    ## Find the latest cpv which already has the keywords we need
    for item in cp_kws:
        # If an old release cycle has been specified, do some version matching
        if old_rel and not belongs_release(item[0], old_rel):
            continue
        # XXX: Random heuristic, say 3/4th of the keywords are new
        if len(best_old[1]) < len(item[1])*3/4:
            # The latest package with most keywords
            best_old = item

    ## Find the latest cpv that needs keywords
    if best_old in cp_kws:
        index = cp_kws.index(best_old)
    else:
        debug_print('%s has no vers from the release %s (TODO)' % (cp, old_rel))
        if DEBUG:
            debug_print('cp_kws: %s' % cp_kws)
            debug_print('best_old: %s' % best_old)
        return (None, None)
    remember = None
    while index >= 0:
        best_new = cp_kws[index]
        # If a new release cycle has been specified, do some version matching
        if new_rel:
            if belongs_release(best_new[0], new_rel):
                # Remember this index as the last one that matched
                remember = index
            elif index is 0:
                if remember is not None:
                    # Nothing else matched, the last one is what we want
                    best_new = cp_kws[remember]
                else:
                    # Nothing matched.
                    best_new = None
        index -= 1

    ## Return [cpv, [keywords]] for old and new
    return best_old, best_new

#######################
## Use the Functions ##
#######################
for i in open(CP_FILE).readlines():
    if i.startswith('#') or not i[:-1]:
        continue
    (best_old, best_new) = latest_kws(i[:-1])

    # Either both are None (which means no version for the release was found)
    # or both are the same (which means the latest cpv already has keywords)
    if best_old is best_new:
        debug_print('No keywording candidate for %s' % i[:-1])
        continue

    # Generate a list of kws that need to be updated
    kws_wanted = []
    for kw in best_old[1]:
        if kw not in best_new[1]:
            kws_wanted.append(kw)
    # FIXME: Alignment needs to be done on the final output
    print flatten([best_new[0]]+kws_wanted)
