# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-libnotify/pidgin-libnotify-0.14.ebuild,v 1.7 2010/07/22 20:19:32 pva Exp $

EAPI="2"

inherit eutils

DESCRIPTION="pidgin-libnotify provides popups for pidgin via a libnotify interface"
HOMEPAGE="http://gaim-libnotify.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaim-libnotify/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls debug"

RDEPEND=">=x11-libs/libnotify-0.7.0
	net-im/pidgin[gtk]
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-showbutton.patch
	epatch "${FILESDIR}"/${PN}-port-to-libnotify-0.7.patch
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
	find "${D}" -name '*.la' -delete
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO VERSION || die
}
