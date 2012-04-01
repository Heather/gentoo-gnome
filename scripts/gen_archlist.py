#!/usr/bin/env python2
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
# NOTE: This script assumes that there are no broken keyword deps
# 
# BUGS:
# * belongs_release() is a very primitive function, which means usage of old/new
#   release numbers gives misleading output
# * Will show multiple versions of the same package in the output sometimes.
#   This happens when a cp is specified in the cpv list, and is resolved as
#   a dependency as well.
# TODO:
# * Support recursive checking of needed keywords in deps
#

from __future__ import division
import os, sys
import portage

###############
## Constants ##
###############
#GNOME_OVERLAY = PORTDB.getRepositoryPath('gnome')
portage.portdb.porttrees = [portage.settings['PORTDIR']]
STABLE_ARCHES = ('alpha', 'amd64', 'arm', 'hppa', 'ia64', 'm68k', 'ppc',
        'ppc64', 's390', 'sh', 'sparc', 'x86')
UNSTABLE_ARCHES = ('~alpha', '~amd64', '~arm', '~hppa', '~ia64', '~m68k', '~ppc',
        '~ppc64', '~s390', '~sh', '~sparc', '~x86', '~x86-fbsd')
ALL_ARCHES = STABLE_ARCHES+UNSTABLE_ARCHES
SYSTEM_PACKAGES = []
LINE_SEP = ''

##############
## Settings ##
##############
DEBUG = False
EXTREME_DEBUG = False
CHECK_DEPS = False
APPEND_SLOTS = False
# Check for stable keywords
STABLE = True

#################
## Preparation ##
#################
ALL_CPV_KWS = []
OLD_REL = None
NEW_REL = None
if __name__ == "__main__":
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
        print 'WARNING: the logic for old_rel & new_rel is very incomplete. See TODO'
        sys.exit(0)
if len(sys.argv) > 2:
    OLD_REL = sys.argv[2]
    if len(sys.argv) > 3:
        NEW_REL = sys.argv[3]
ARCHES = None
if STABLE:
    ARCHES = STABLE_ARCHES
else:
    ARCHES = UNSTABLE_ARCHES

if os.environ.has_key('CHECK_DEPS'):
    CHECK_DEPS = os.environ['CHECK_DEPS']

if os.environ.has_key('APPEND_SLOTS'):
    APPEND_SLOTS = os.environ['APPEND_SLOTS']

if not STABLE:
    print 'Currently broken for anything except STABLEREQ'
    print 'Please set STABLE to True'
    sys.exit(1)

######################
## Define Functions ##
######################
def flatten(list, sep=' '):
    "Given a list, returns a flat string separated by 'sep'"
    return sep.join(list)

def n_sep(n, sep=' '):
    tmp = ''
    for i in range(0, n):
        tmp += sep
    return tmp

def debug(*strings):
    from portage.output import EOutput
    ewarn = EOutput().ewarn
    ewarn(flatten(strings))

def nothing_to_be_done(atom, type='cpv'):
    if STABLE:
        debug('%s %s: already stable, ignoring...' % (type, atom))
    else:
        debug('%s %s: already keyworded, ignoring...' % (type, atom))

def make_unstable(kws):
    "Takes a keyword list, and returns a list with them all unstable"
    nkws = []
    for kw in kws:
        if not kw.startswith('~'):
            nkws.append('~'+kw)
        else:
            nkws.append(kw)
    return nkws

def belongs_release(cpv, release):
    "Check if the given cpv belongs to the given release"
    # FIXME: This failure function needs better logic
    if CHECK_DEPS:
        raise Exception('This function is utterly useless with RECURSIVE mode')
    return get_ver(cpv).startswith(release)

def issystempackage(cpv):
    for i in SYSTEM_PACKAGES:
        if cpv.startswith(i):
            return True
    return False

def get_kws(cpv, arches=ARCHES):
    """
    Returns an array of KEYWORDS matching 'arches'
    """
    kws = []
    for kw in portage.portdb.aux_get(cpv, ['KEYWORDS'])[0].split():
        if kw in arches:
            kws.append(kw)
    return kws

def do_not_want(cpv, release=None):
    """
    Check if a package atom is p.masked or has empty keywords, or does not
    belong to a release
    """
    if release and not belongs_release(cpv, release) or not \
        portage.portdb.visible([cpv]) or not get_kws(cpv, arches=ALL_ARCHES):
        return True
    return False

def match_wanted_atoms(atom, release=None):
    """
    Given an atom and a release, return all matching wanted atoms ordered in
    descending order of version
    """
    atoms = []
    # xmatch is stupid, and ignores ! in an atom...
    if atom.startswith('!'): return []
    for cpv in portage.portdb.xmatch('match-all', atom):
        if do_not_want(cpv, release):
            continue
        atoms.append(cpv)
    atoms.reverse()
    return atoms

def get_best_deps(cpv, kws, release=None):
    """
    Returns a list of the best deps of a cpv, optionally matching a release, and
    with max of the specified keywords
    """
    atoms = portage.portdb.aux_get(cpv, ['DEPEND', 'RDEPEND', 'PDEPEND'])
    atoms = ' '.join(atoms).split() # consolidate atoms
    atoms = list(set(atoms)) # de-duplicate
    deps = set()
    tmp = []
    for atom in atoms:
        if atom.find('/') is -1:
            # It's not a dep atom
            continue
        ret = match_wanted_atoms(atom, release)
        if not ret:
            if DEBUG: debug('We encountered an irrelevant atom: %s' % atom)
            continue
        best_kws = ['', []]
        for i in ret:
            if STABLE:
                # Check that this version has unstable keywords
                ukws = make_unstable(kws)
                cur_ukws = set(make_unstable(get_kws(i, arches=kws+ukws)))
                if cur_ukws.intersection(ukws) != set(ukws):
                    best_kws = 'none'
                    if DEBUG: debug('Insufficient unstable keywords in: %s' % i)
                    continue
            cur_match_kws = get_kws(i, arches=kws)
            if set(cur_match_kws) == set(kws):
                # This dep already has all keywords
                best_kws = 'alreadythere'
                break
            # Select the version which needs least new keywords
            if len(cur_match_kws) > len(best_kws[1]):
                best_kws = [i, cur_match_kws]
            elif not best_kws[0]:
                # This means that none of the versions have any of the stable
                # keywords that *we checked* (i.e. kws).
                best_kws = [i, []]
        if best_kws == 'alreadythere':
            if DEBUG: nothing_to_be_done(atom, type='dep')
            continue
        elif best_kws == 'none':
            continue
        elif not best_kws[0]:
            # We get this when the if STABLE: block above rejects everything.
            # This means that this atom does not have any versions with unstable
            # keywords matching the unstable keywords of the cpv that pulls it.
            # This mostly happens because an || or use dep exists. However, we
            # make such deps strict while parsing
            # XXX: We arbitrarily select the most recent version for this case
            deps.add(ret[0])
        elif not best_kws[1]:
            # This means that none of the versions have any of the stable
            # keywords that *we checked* (i.e. kws). Hence, we do another pass;
            # this time checking *all* keywords.
            #
            # XXX: We duplicate some of the things from the for loop above
            # We don't need to duplicate anything that caused a 'continue' or
            # a 'break' above
            ret = match_wanted_atoms(atom, release)
            best_kws = ['', []]
            for i in ret:
                cur_kws = get_kws(i)
                if len(cur_kws) > len(best_kws[1]):
                    best_kws = [i, cur_kws]
                elif not best_kws[0]:
                    # This means that none of the versions have any of the stable
                    # keywords *at all*. No choice but to arbitrarily select the
                    # latest version in that case.
                    best_kws = [i, []]
            deps.add(best_kws[0])
        else:
            deps.add(best_kws[0])
    return list(deps)

def max_kws(cpv, release=None):
    """
    Given a cpv, find the intersection of "most keywords it can have" and
    "keywords it has", and returns a sorted list

    If STABLE; makes sure it has unstable keywords right now

    Returns [] if current cpv has best keywords
    Returns None if no cpv has keywords
    """
    current_kws = get_kws(cpv, arches=ALL_ARCHES)
    maximum_kws = [] # Maximum keywords that a cpv has
    missing_kws = []
    for atom in match_wanted_atoms('<='+cpv, release):
        kws = get_kws(atom)
        if len(kws) > len(maximum_kws):
            maximum_kws = kws
        for kw in kws:
            if kw not in missing_kws+current_kws:
                if STABLE and '~'+kw not in current_kws:
                    continue
                missing_kws.append(kw)
    missing_kws.sort()
    if maximum_kws != []:
        return missing_kws
    else:
        # No cpv has the keywords we need
        return None

# FIXME: This is broken
def kws_wanted(cpv_kws, prev_cpv_kws):
    "Generate a list of kws that need to be updated"
    wanted = []
    for kw in prev_cpv_kws:
        if kw not in cpv_kws:
            if STABLE and '~'+kw not in cpv_kws:
                # Ignore if no keywords at all
                continue
            wanted.append(kw)
    return wanted

def gen_cpv_kws(cpv, kws_aim, depgraph):
    depgraph.add(cpv)
    cpv_kw_list = [[cpv, kws_wanted(get_kws(cpv, arches=ALL_ARCHES), kws_aim)]]
    if not cpv_kw_list[0][1]:
        # This happens when cpv has less keywords than kws_aim
        # Usually happens when a dep was an || dep, or under a USE-flag which is
        # masked in some profiles. We make all deps strict in get_best_deps()
        # So... let's just stabilize it on all arches we can, and ignore for
        # keywording since we have no idea about that.
        if not STABLE:
            debug('MEH')
            nothing_to_be_done(cpv, type='dep')
            return None
        wanted = get_kws(cpv, arches=make_unstable(kws_aim))
        cpv_kw_list = [[cpv, wanted]]
    if CHECK_DEPS and not issystempackage(cpv):
        deps = get_best_deps(cpv, cpv_kw_list[0][1], release=NEW_REL)
        if EXTREME_DEBUG:
            debug('The deps of %s are %s' % (cpv, deps))
        for dep in deps:
            if dep in depgraph:
                continue
            depgraph.add(dep)
            # Assumes that keyword deps are OK if STABLE
            dep_deps = gen_cpv_kws(dep, cpv_kw_list[0][1], depgraph)
            dep_deps.reverse()
            for i in dep_deps:
                # Make sure we don't already have the same [cpv, [kws]]
                if i not in ALL_CPV_KWS and i not in cpv_kw_list:
                    cpv_kw_list.append(i)
    cpv_kw_list.reverse()
    return cpv_kw_list

def fix_nesting(nested_list):
    """Takes a list of unknown nesting depth, and gives a nice list with each
    element of the form [cpv, [kws]]"""
    index = 0
    cpv_index = -1
    nice_list = []
    # Has an unpredictable nesting of lists; so we flatten it...
    flat_list = portage.flatten(nested_list)
    # ... and re-create a nice list for us to use
    while index < len(flat_list):
        if portage.catpkgsplit(flat_list[index]):
            cpv_index += 1
            nice_list.append([flat_list[index], []])
        else:
            nice_list[cpv_index][1].append(flat_list[index])
        index += 1
    return nice_list

def consolidate_dupes(cpv_kws):
    """
    Consolidate duplicate cpvs with differing keywords

    Cannot handle cps with different versions since we don't know if they are
    inter-changeable
    """
    cpv_indices = {}

    # Find all indices of each cpv
    for each in cpv_kws:
        # Comments/whitespace carried over from original list
        if type(each) is not list:
            continue
        else:
            if not cpv_indices.has_key(each[0]):
                cpv_indices[each[0]] = []
            cpv_indices[each[0]].append(cpv_kws.index(each))

    # Replace the keywords of each cpv with the union of all keywords in the
    # list belonging to this cpv
    for each in cpv_kws:
        # Ignore comments/whitespace carried over from original list
        if type(each) is not list:
            continue
        kws = set()
        for index in cpv_indices[each[0]]:
            kws.update(cpv_kws[index][1])
        each[1] = list(kws)
        each[1].sort()

    index = 0
    deduped_cpv_kws = cpv_kws[:]
    deduped_cpv_kws.reverse()
    while index < len(deduped_cpv_kws):
        item = deduped_cpv_kws[index]
        if type(item) is not list:
            index += 1
            continue
        if deduped_cpv_kws.count(item) is 1:
            index += 1
        else:
            while deduped_cpv_kws.count(item) is not 1:
                deduped_cpv_kws.remove(item)
    deduped_cpv_kws.reverse()

    return deduped_cpv_kws

def get_per_slot_cpvs(cpvs):
    "Classify the given cpvs into slots, and yield the best atom for each slot"
    slots = set()
    for cpv in cpvs:
        slot = portage.portage.portdb.aux_get(cpv, ['SLOT'])[0]
        if slot in slots:
            continue
        slots.add(slot)
        yield cpv

def append_slots(cpv_kws):
    "Append slots at the end of cpv atoms"
    slotifyed_cpv_kws = []
    for (cpv, kws) in cpv_kws:
        slot = portage.portage.portdb.aux_get(cpv, ['SLOT'])[0]
        cpv = "%s:%s" % (cpv, slot)
        slotifyed_cpv_kws.append([cpv, kws])
    return slotifyed_cpv_kws

# FIXME: This is broken
def prettify(cpv_kws):
    "Takes a list of [cpv, [kws]] and prettifies it"
    max_len = 0
    kws_all = []
    pretty_list = []
    cpv_block_size = 0

    for each in cpv_kws:
        # Ignore comments/whitespace carried over from original list
        if type(each) is not list:
            continue
        # Find the atom with max length (for output formatting)
        if len(each[0]) > max_len:
            max_len = len(each[0])
        # Find the set of all kws listed
        for kw in each[1]:
            if kw not in kws_all:
                kws_all.append(kw)
    kws_all.sort()

    for each in cpv_kws:
        # Handle comments/whitespace carried over from original list
        if type(each) is not list:
            # If the prev cpv block has just one line, don't print an extra \n
            # XXX: This code relies on blocks of dep-cpvs being separated by \n
            if CHECK_DEPS and cpv_block_size is 1:
                cpv_block_size = 0
                continue
            pretty_list.append([each, []])
            cpv_block_size = 0
            continue
        # The size of the current cpv list block
        cpv_block_size += 1
        # Pad the cpvs with space
        each[0] += n_sep(max_len - len(each[0]))
        for i in range(0, len(kws_all)):
            if i == len(each[1]):
                # Prevent an IndexError
                # This is a problem in the algo I selected
                each[1].append('')
            if each[1][i] != kws_all[i]:
                # If no arch, insert space
                each[1].insert(i, n_sep(len(kws_all[i])))
        pretty_list.append([each[0], each[1]])
    return pretty_list

#######################
## Use the Functions ##
#######################
# cpvs that will make it to the final list
if __name__ == "__main__":
    index = 0
    array = []

    for i in open(CP_FILE).readlines():
        cp = i[:-1]
        if cp.startswith('#') or cp.isspace() or not cp:
            ALL_CPV_KWS.append(cp)
            continue
        if cp.find('#') is not -1:
            raise Exception('Inline comments are not supported')
        if portage.catpkgsplit(cp):
            # categ/pkg is already a categ/pkg-ver
            atoms = [cp]
        else:
            # Get all the atoms matching the given cp
            cpvs = match_wanted_atoms(cp, release=NEW_REL)

        for cpv in get_per_slot_cpvs(cpvs):
            if not cpv:
                debug('%s: Invalid cpv' % cpv)
                continue
            kws_missing = max_kws(cpv, release=OLD_REL)
            if kws_missing == []:
                # Current cpv has the max keywords => nothing to do
                nothing_to_be_done(cpv)
                continue
            elif kws_missing == None:
                debug ('No versions with stable keywords for %s' % cpv)
                # No cpv with stable keywords => select latest
                arches = make_unstable(ARCHES)
                kws_missing = [kw[1:] for kw in get_kws(cpv, arches)]
            ALL_CPV_KWS += fix_nesting(gen_cpv_kws(cpv, kws_missing, set()))
            if CHECK_DEPS:
                ALL_CPV_KWS.append(LINE_SEP)

    ALL_CPV_KWS = consolidate_dupes(ALL_CPV_KWS)
    if APPEND_SLOTS:
        ALL_CPV_KWS = append_slots(ALL_CPV_KWS)

    for i in prettify(ALL_CPV_KWS):
        print i[0], flatten(i[1])
