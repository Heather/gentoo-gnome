# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/harfbuzz/harfbuzz-0.7.0_pre20110904.ebuild,v 1.4 2012/05/05 08:02:40 jdhore Exp $

EAPI="4"

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/HarfBuzz"
SRC_URI="http://www.freedesktop.org/software/${PN}/release/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-libs/icu
	media-gfx/graphite2
	media-libs/freetype:2
	>=x11-libs/cairo-1.8[X]
"
DEPEND="${RDEPEND}
	dev-util/ragel
	virtual/pkgconfig
"

src_prepare() {
	default

	# FIXME: Weird linking failures
	sed -i 's/^\(noinst_PROGRAMS\).*/\1 = /' src/Makefile.in || die
	sed -i 's/^\(bin_PROGRAMS\).*/\1 = /' util/Makefile.in || die
	sed -i 's/^\(SUBDIRS.*\)test/\1/' Makefile.in || die
}

src_configure() {
	# this packge needs build system update because
	# all the deps are automagic
	econf \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
