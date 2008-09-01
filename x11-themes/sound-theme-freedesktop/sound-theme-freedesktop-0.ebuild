# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Freedesktop Sound Theme based on the new Freedesktop standard"
HOMEPAGE="http://www.freedesktop.org/wiki/Specifications/sound-theme-spec"
SRC_URI="http://0pointer.de/public/${PN}.tar.gz"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/freedesktop"

src_install() {
	local dest="/usr/share/sounds/freedesktop"
	mkdir -p "${D}${dest}"
	mv index.theme stereo "${D}${dest}" || die "Install failed"
	dodoc README || die
}
