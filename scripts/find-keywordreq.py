#!/usr/bin/env python2

""" Helper module to print a list of needed keywords provided a list of cpv.

Can be tweaked to either compute keyword request from a list of defined arches or from older revisions available stable keywords.
"""

import os
import sys

import portage

from pprint import pprint

ARCH_GNOME=['alpha', 'amd64', 'arm', 'hppa', 'ia64', 'ppc', 'ppc64', 'sh', 'sparc', 'x86']
ARCH_DEV=["mips", "amd64-fbsd", "sparc-fbsd", "x86-fbsd"]
ARCH_EXP=["ppc-aix", "x86-freebsd", "x64-freebsd", "hppa-hpux", "ia64-hpux", "x86-interix", "mips-irix", "amd64-linux", "arm-linux", "ia64-linux", "x86-linux", "ppc-macos", "x86-macos", "x64-macos", "m68k-mint", "x86-netbsd", "ppc-openbsd", "x86-openbsd", "x64-openbsd", "sparc-solaris", "sparc64-solaris", "x64-solaris", "x86-solaris", "x86-winnt"]

def package_sort(item1, item2):
	""" Sort revisions """

	return portage.dep.pkgcmp(portage.dep.pkgsplit(item1), portage.dep.pkgsplit(item2))

def main():
	""" Main function """

	api = portage.portdbapi()
	api._aux_cache_keys.clear()
	api._aux_cache_keys.update(["EAPI", "KEYWORDS", "SLOT"])

	root = '/'
	trees = {
		root : {'porttree' : portage.portagetree(root)}
	}
	portdb = trees[root]['porttree'].dbapi
	#portdb._aux_cache_keys.clear()
	#portdb._aux_cache_keys.update(["EAPI", "KEYWORDS", "SLOT"])

	#pprint(api.porttrees)

	for atom in sys.argv:

		arches = {}
		keywords = {}
		best_revision = {}
		need_keyword = {}
		revisions = api.cp_list(atom, mytree=api.porttrees[0])
		rev_keywords = {}
		max_arch_list = []

		# Select best revision
		revisions.sort(package_sort)

		# Build maximum possible arches list
		for revision in revisions:
			# print revision

			aux_kw, slot = api.aux_get(revision, ['KEYWORDS', 'SLOT'])
			aux_kw = [kw for kw in aux_kw.replace('~', '').split() if kw and not kw.startswith('-') and kw not in ARCH_DEV and kw not in ARCH_EXP]

			# Build best set of keywords per SLOT
			for kw in aux_kw:
				if slot in keywords:
					if kw not in keywords[slot]:
						keywords[slot].append(kw)
				else:
					keywords[slot] = [kw]

			if not keywords or not slot in keywords:
				revisions.remove(revision)
			else:
				if revision.endswith("9999"):
					revisions.remove(revision)
					continue
				best_revision[slot] = revision
				keywords[slot] = ARCH_GNOME
				need_keyword[slot] = [kw for kw in keywords[slot] if kw not in aux_kw]

		# Show missing arches
		for slot in keywords:
			if need_keyword[slot]:
#				keycheck_incrementals = tuple(x for x in portage.const.INCREMENTALS if x != 'ACCEPT_KEYWORDS')
				# for package.use.mask support inside dep_check
#				dep_settings = portage.config(
#					config_incrementals = keycheck_incrementals,
#					local_config = False)
#				dep_settings.setcpv(revision)
#				dep_settings["ACCEPT_KEYWORDS"] = " ".join(keywords[slot] + need_keyword[slot])
#
#				for dep_type in ('DEPEND', 'RDEPEND', 'PDEPEND'):
#					aux_dep = api.aux_get(revision, [dep_type])[0]
#					print portage.dep_check(aux_dep, portdb, dep_settings, use='all', trees=trees, mode='minimum-visible')
#

				kw_print = ""
				for kw in ARCH_GNOME:
					kw_print += " "
					if kw in need_keyword[slot]:
						kw_print += kw
					else:
						kw_print += " " * len(kw)

				print "%-60s:" % best_revision[slot], kw_print
			

if __name__ == "__main__":
	main()
