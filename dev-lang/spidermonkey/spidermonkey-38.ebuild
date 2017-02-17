# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="http://ppa.launchpad.net/ricotz/testing/ubuntu/pool/main/m/mozjs38/libmozjs-38-dev_38.2.1~rc0-0ubuntu1~16.10~wfg6_amd64.deb"

SLOT="0"

#doesn't work
#KEYWORDS="~amd64"

IUSE=""
RESTRICT="strip"
S="${WORKDIR}"

LICENSE="NPL-1.1"
SLOT="38"

src_prepare() {
	unpack ./control.tar.gz
	unpack ./data.tar.xz
}

src_compile() {
	mkdir -p "${S}"/usr/lib64/ || die
	mv "${S}"/usr/lib/x86_64-linux-gnu/* "${S}"/usr/lib64/ || die
	rm -rf "${S}"/usr/lib/x86_64-linux-gnu/ || die
}

src_install(){
	doins -r usr	
	fperms 755 /usr/bin/js38-config
}
