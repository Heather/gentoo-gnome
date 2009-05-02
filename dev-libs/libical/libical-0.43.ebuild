# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libical/libical-0.33-r1.ebuild,v 1.1 2008/10/01 15:11:33 s4t4n Exp $
EAPI=2

inherit flag-o-matic

DESCRIPTION="An implementation of basic iCAL protocols from citadel, previously known as aurore"
HOMEPAGE="http://www.citadel.org"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

# https://sourceforge.net/tracker2/index.php?func=detail&aid=2196790&group_id=16077&atid=116077
RESTRICT="test"

src_prepare() {
	# Do not waste time building examples
	sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed failed"

	# Fix bug #66377
	append-ldflags -lpthread
}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TEST THANKS TODO \
		doc/{AddingOrModifyingComponents,UsingLibical}.txt || die "dodoc failed"

	if use examples; then
		rm examples/Makefile* examples/CMakeLists.txt
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
