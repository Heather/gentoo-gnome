# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Parser and analyzer for backtraces produced by gdb"
HOMEPAGE="https://fedorahosted.org/btparser/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-maintainer-mode
}

src_install() {
	default
	use static-libs || find "${D}" -name '*.la' -exec rm -f {} +
}
