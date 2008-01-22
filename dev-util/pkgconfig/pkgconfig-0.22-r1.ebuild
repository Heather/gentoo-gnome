# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgconfig/pkgconfig-0.22.ebuild,v 1.10 2007/12/11 17:15:49 vapier Exp $

inherit flag-o-matic eutils

MY_PN="pkg-config"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Package config system that manages compile/link flags"
HOMEPAGE="http://pkgconfig.freedesktop.org/wiki/"
SRC_URI="http://pkgconfig.freedesktop.org/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="hardened elibc_FreeBSD"

RDEPEND=">=dev-libs/glib-2"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${MY_PN}-0.21-fix-tests.patch"
}

src_compile() {
	local myconf=

	# Force using all the requirements when linking, so that needed -pthread
	# lines are inherited between libraries
	use elibc_FreeBSD && myconf="${myconf} --enable-indirect-deps"

	use ppc64 && use hardened && replace-flags -O[2-3] -O1

	econf ${myconf} --with-installed-glib || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog NEWS README
}
