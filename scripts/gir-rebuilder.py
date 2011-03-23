#!/usr/bin/env python2
# vim: set sts=4 sw=4 et tw=90 :
# 
# Author(s): Nirbheek Chauhan <nirbheek@gentoo.org>
# Idea-by: Arun Raghavan <ford_prefect@gentoo.org>
# Tested-by: Arun Raghavan <ford_prefect@gentoo.org>
#
# Script to find outdated gobject-introspection .gir files, associate them with packages
# and then recompile/upgrade them

import os
import os.path as osp
import sys
import re
import subprocess
from xml.dom import minidom as dom

import portage
from portage.versions import vercmp
from portage.output import EOutput
from _emerge.stdout_spinner import stdout_spinner

###############
## Variables ##
###############
quiet = False
force = False
root = '/'
gir_dirs = ['/usr/share/gir-1.0']
girs = {}
girversion = ''
gi = 'gobject-introspection'
settings = portage.settings
eoutput = EOutput()
spinner = stdout_spinner()

###############
## Functions ##
###############
def usage():
    print """gir-rebuilder: Rebuilds gobject-introspection typelibs and girs in the following directories:
 %s

Usage: %s [--force] [ARGUMENTS TO EMERGE]

Arguments:
  --help            This text
  --force           Force rebuilding of *all* girs and typelibs

  All other arguments are passed to portage
    """ % ('\n '.join(gir_dirs), sys.argv[0])

def get_version(gir):
    return dom.parse(gir).getElementsByTagName('repository')[0].getAttribute('version')

def get_contents(cpv):
    cpv = portage.catsplit(cpv)
    return set(portage.dblink(cpv[0], cpv[1], root, settings).getcontents().keys())

################
## Parse Args ##
################
if '--help' in sys.argv:
    usage()
    exit(0)
if '--force' in sys.argv:
    force = True
    sys.argv.remove('--force')

##############
## Set vars ##
##############
if os.environ.has_key('ROOT'):
    root = os.environ['ROOT']
vardbapi = portage.vardbapi()
# Find the latest g-i
# XXX: Assumes there's only one slot for g-i
eoutput.ebegin("Finding current GIRepository version")
gi = vardbapi.match(gi)[0]
for each in get_contents(gi):
    # Find GIRepository-$ver.gir, and get the internal version
    if re.match('.*GIRepository[^/]+\.gir$', each):
        girepository = each
        break
else:
    raise Exception("GIRepository .gir not found")
girversion = get_version(girepository)
eoutput.eend(0)
eoutput.einfo("Current GIRepository version is " + girversion)

##########
## Work ##
##########
if force:
    eoutput.ebegin("Finding GIR files")
else:
    eoutput.ebegin("Finding broken GIR files")
files_list = set()
for dir in gir_dirs:
    # Walk the gir directories to find files
    for (path, dirs, files) in os.walk(osp.join(root, dir)):
        for f in files:
            if not f.endswith('.gir'):
                continue
            if force:
                files_list.add(osp.join(path, f))
                continue
            spinner.update()
            # Get the .gir version
            version = get_version(osp.join(path, f))
            # If not the same version as GIRepository.gir, rebuild it
            if vercmp(girversion, version) != 0:
                eoutput.ewarn("GIR file to be rebuilt: " + \
                                         osp.join(path, f))
                files_list.add(osp.join(path, f))
eoutput.eend(0)

# FIXME: Doesn't warn if it was unable to assign a file to a package
rebuild_list = set()
if files_list:
    eoutput.ebegin("Assigning files to packages")
    files_assigned = set()
    for cpv in vardbapi.cpv_all():
        spinner.update()
        # If some of the files of this package are in the gir file list
        files_owned = get_contents(cpv).intersection(files_list)
        if files_owned:
            files_assigned.update(files_owned)
            slot = vardbapi.aux_get(cpv, ['SLOT'])[0]
            # We strip the version, but maintain the slot (same as revdep-rebuild)
            rebuild_list.add(portage.pkgsplit(cpv)[0]+':'+slot)
    files_unassigned = files_list.symmetric_difference(files_assigned)
    if files_unassigned:
        for file in files_unassigned:
            eoutput.ewarn("Unable to assign file to package: " + \
                                     osp.join(path, file))
eoutput.eend(0)

if files_list and rebuild_list:
    eoutput.einfo("All done, starting rebuild")
    command = "emerge --oneshot " + ' \\\n'.join(sys.argv[1:]+list(rebuild_list))
    print command
    # Run emerge
    subprocess.call(command, shell=True)
else:
    eoutput.einfo("Everything seems to be in order, nothing to be rebuilt")
