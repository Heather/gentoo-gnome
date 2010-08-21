#!/bin/bash

LIBS=${@:-"libgnome-2 libgnomeui-2 libgnomevfs-2 libbonobo-2 libbonoboui-2 libbonobo-activation libORBit-2 libORBitCosNaming-2 libgnomeprint-2-2 libgnomeprintui-2-2 libgnomecanvas-2 libart_lgpl_2 libglade-2.0"}

pushd . >/dev/null
cd /var/db/pkg

for lib in $LIBS; do
	printf "%22s" "${lib}: "
	lib_owner=`qfile -eCq /usr/lib/${lib}*.so`
	lib_user_file_count=`grep "${lib}" */*/NEEDED.ELF.2 --exclude="${lib_owner}/NEEDED.ELF.2" |wc -l`
	lib_user_package_count=`grep "${lib}" */*/NEEDED.ELF.2 --exclude="${lib_owner}/NEEDED.ELF.2" -l |wc -l`
	printf "needed by %3d files from %2d packages\n" ${lib_user_file_count} ${lib_user_package_count}
done

popd >/dev/null
