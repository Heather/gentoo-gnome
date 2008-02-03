# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="libspectre is a small library for rendering Postscript documents"
HOMEPAGE="http://libspectre.freedesktop.org/wiki/libspectre"
SRC_URI="http://libspectre.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=app-text/ghostscript-gpl-8.61"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
		--enable-asserts \
		--disable-test \
		|| die "Configure failed!"

	emake || die "Make failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README NEWS
}

