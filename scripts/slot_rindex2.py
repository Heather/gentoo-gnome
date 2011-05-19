#!/usr/bin/python
# -*- coding: utf-8 -*-

""" Checks what slots are used for a package in its reverse dependencies. """

import portage

import sys
#from pprint import pprint

def main():
    trees = portage.create_trees()
    trees["/"]["porttree"].settings = portage.settings
    portdb = trees["/"]["porttree"]
    portdb.dbapi.settings = portage.settings
    portdb.dbapi.porttrees = [portage.portdb.porttree_root]

    # does it make sense to remove _all_ useless stuff or just leave it as it is?
    #portdb.dbapi._aux_cache_keys.clear()
    #portdb.dbapi._aux_cache_keys.update(["EAPI", "KEYWORDS", "SLOT"])

    res_slots = {}

    # Loop through all package names
    for cp in portdb.dbapi.cp_all():
        #print(cp)

        # Get versions
        cpvrs = portdb.dbapi.xmatch('match-all', cp)

        # Group by slots
        slots = {}
        for cpvr in cpvrs:
            slot = portdb.dbapi.aux_get(cpvr, ["SLOT"])[0]
            if slot is None:
                slot = 0
            if not slot in slots:
                slots[slot] = []
            slots[slot].append(cpvr)

        # XXX: Walk through slots (walk twice for ~arch and arch)
        for slot in sorted(slots):
            cpvr = portage.versions.best(slots[slot])
            depends = portdb.dbapi.aux_get(cpvr, ['DEPEND', 'RDEPEND', 'PDEPEND'])
            depends = set(portage.dep.use_reduce(' '.join(depends), matchall=True, flat=True))
            depends = [dep for dep in depends if portage.dep.isvalidatom(dep)]

            #print('DEPEND:')
            #pprint(depends)

            for depend in depends:
                if portage.dep.dep_getkey(depend) == sys.argv[1]:
                    mypkg_slot = portage.dep.dep_getslot(depend)
                    if mypkg_slot is None:
                        mypkg_slot = "unset"

                    if mypkg_slot not in res_slots:
                        res_slots[mypkg_slot] = [(cpvr, depend)]
                    else:
                        res_slots[mypkg_slot].append((cpvr, depend))
                    #print(portage.dep.dep_getkey(depend) + ' uses ' + sys.argv[1] + ' slot ' +  portage.dep.dep_getslot(depend))

    for slot in sorted(res_slots):
        print('%s:%s' % (sys.argv[1], slot))
        for rescpv in res_slots[slot]:
            print('    %s (as %s)' % rescpv)


if __name__ == "__main__":
    main()

## vim:set sts=4 ts=4 sw=4 expandtab:
