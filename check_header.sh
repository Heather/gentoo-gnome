#!/bin/bash -e

# ::gentoo main tree switched to git recently
# As a result ebuild header hac changed a bit:
#    # $Header: /var/cvsroot/gentoo-x86/eclass/ghc-package.eclass,v 1.34 2012/09/14 02:51:23 gienah Exp $
# now became just an
#    # $Id$

check_copyright() {
    local e=$1
    
    echo 'FIX "# Copyright" in: '"$e"
    sed -e 's/^# Copyright .*/# Copyright 1999-2017 Gentoo Foundation/g' -i "${e}"
}

check_header() {
    local e=$1

    echo 'FIX "# $Header:" in: '"$e"
    sed -e 's/^# \$Header: .*\$$/# $Id$/g' -i "${e}"
}

while read e; do
    while read l
    do
        if [[ $l == '# Copyright 1999-'* ]]; then
            check_copyright "$e"
        fi
        if [[ $l == '# $Header:'* ]]; then
            check_header "$e"
            break
        fi
    done < "$e"
done < <(find . -type f)
