#!/usr/bin/env python2
# vim: set sts=4 sw=4 et tw=0 :
#
# Author(s): Nirbheek Chauhan <nirbheek@gentoo.org>
# License: MIT
#
# Bump gstreamer plugins to the version specified
# You must have your cvs directory as PORTDIR
#

import os
import shutil
import subprocess
import sys

import portage
from portage.output import colorize

def usage():
    print "Usage: $0 <base|good|bad|ugly> <version> [core version] [base version]"
    print ""
    print "  If core/base version is unspecified or blank, it's assumed to be the same"

if len(sys.argv) < 3 or len(sys.argv) > 5:
    usage()
    sys.exit(1)

###################
## Configuration ##
###################
GSTLIB = sys.argv[1]
GSTLIBVER = sys.argv[2]
GSTCOREVER = ''
GSTBASEVER = ''
if len(sys.argv) == 5:
    GSTCOREVER = sys.argv[3]
    GSTBASEVER = sys.argv[4]
elif len(sys.argv) == 4:
    GSTCOREVER = sys.argv[3]

##################
## Parse Config ##
##################
PORTDIR = portage.settings["PORTDIR"]
portage.portdb.porttrees = [PORTDIR]
GSTPREFIX = 'gst-plugins-'
GSTECLASS = GSTPREFIX + GSTLIB
GSTLIB = 'media-libs/' + GSTPREFIX + GSTLIB
GSTPLUGIN_CPVS = []
GSTCAT = 'media-plugins'
GSTLIBS = {'media-libs/gstreamer': GSTCOREVER,
           'media-libs/gst-plugins-base': GSTBASEVER,
           GSTLIB: GSTLIBVER,}

###############
## Functions ##
###############
def print_colorize(color, text):
    print colorize(color, " * ") + text

def get_p(pkg):
    "pkg must contain at least the package name"
    if not portage.isjustname(pkg):
        return portage.catpkgsplit(pkg)[1]
    return portage.catsplit(pkg)[-1]

def get_v(cpv):
    "cpv can be anything"
    if portage.isjustname(cpv):
        raise Exception('Input (%s) has no version!' % cpv)
    pv = portage.pkgsplit(cpv)[-2:]
    if pv[1] == 'r0':
        return pv[0]
    else:
        return '%s-%s' % (pv[0], pv[1])

def get_cp(cpv):
    "cpv must contain package and category"
    return portage.pkgsplit(cpv)[0]

def get_pv(cpv, ver=None):
    if not ver:
        return portage.catsplit(cpv)[-1]
    else:
        return get_p(cpv) + '-' + ver

def get_cpv(cp, ver=None):
    if ver:
        return '%s-%s' % (cp, ver)
    else:
        # Return the latest one instead
        return portage.portdb.xmatch('match-all', cp)[-1]

def get_ebuild_dir(cpv):
    return os.path.join(PORTDIR, get_cp(cpv))

def get_ebuild(cpv):
    return os.path.join(get_pv(cpv)+'.ebuild')

def edit_gstdeps(ebuild):
    # Editing files is hard, let's just use sed
    sed_cmd = ''
    for dep in GSTLIBS.keys():
        # Ignore if wanted-version is empty
        if not GSTLIBS[dep]:
            continue
        # FIXME: This is an approximate regexp for matching versions
        old_dep = '%s-[-0-9._rpe]\+' % dep
        new_dep = '%s-%s' % (dep, GSTLIBS[dep])
        # We need a space at the end for further appending
        sed_cmd += '-e "s|%s|%s|g" ' % (old_dep, new_dep)
    if not sed_cmd:
        # Nothing to do...
        return
    # In-place edit
    sed_cmd = 'sed %s -i %s' % (sed_cmd, ebuild)
    subprocess.check_call(sed_cmd, shell=True)

def isgstplugin(cpv):
    if not cpv.startswith('%s/%s' % (GSTCAT, GSTPREFIX)):
        return False
    # Does it inherit GSTECLASS?
    if not GSTECLASS in portage.portdb.aux_get(cpv, ['INHERITED'])[0].split():
        return False
    return True

################
## Begin Work ##
################

print_colorize("green", "Getting a list of all gst-plugins ...")
for cp in portage.portdb.cp_all(categories=[GSTCAT]):
    cpv = get_cpv(cp)
    if not isgstplugin(cpv):
        continue
    print_colorize("green", "Current package is %s" % cpv)
    GSTPLUGIN_CPVS.append(cpv)
    os.chdir(get_ebuild_dir(cpv))
    old_ebuild = get_ebuild(cpv)
    new_ebuild = get_ebuild(get_cpv(cp, GSTLIBVER))
    print_colorize("green", "Copying %s to %s ..." % (old_ebuild, new_ebuild))
    shutil.copyfile(old_ebuild, new_ebuild)
    print_colorize("green", "Editing gstreamer deps and keywords. A diff will follow ...")
    edit_gstdeps(new_ebuild)
    subprocess.check_call('ekeyword ~all %s' % new_ebuild, shell=True, stdout=subprocess.PIPE)
    try:
        subprocess.check_call('diff -u %s %s' % (old_ebuild, new_ebuild), shell=True)
    except subprocess.CalledProcessError as e:
        # diff returns:
        #   0 if files don't differ
        #   1 if they differ
        #   2 if something went wrong
        if e.returncode == 2:
            raise e
    subprocess.check_call('ebuild %s manifest' % new_ebuild, shell=True)
    print_colorize("green", "Running cvs add ...")
    subprocess.check_call('cvs add %s' % new_ebuild, shell=True)
