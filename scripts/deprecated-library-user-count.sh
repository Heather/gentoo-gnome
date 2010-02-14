#!/bin/bash

LIBS=${@:-"libgnome-2 libgnomeui-2 libgnomevfs-2 libbonobo-2 libbonoboui-2 libbonobo-activation libORBit-2 libORBitCosNaming-2 libgnomeprint-2-2 libgnomeprintui-2-2 libgnomecanvas-2 libart_lgpl_2 libglade-2.0"}

pushd . >/dev/null
cd /var/db/pkg

for lib in $LIBS; do
	echo -n "${lib}: "
	grep "${lib}" */*/NEEDED.ELF.2 |wc -l
done

popd >/dev/null
