# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-0_p40220.ebuild,v 1.3 2009/03/11 21:37:14 klausman Exp $

MY_P="webkit-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkit.org/"
SRC_URI="http://cafe.minaslivre.org/webkit/${MY_P}.tar.gz"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
# geoclue
IUSE="coverage debug gnome-keyring gstreamer svg"

# use sqlite by default
RDEPEND="
	dev-libs/libxslt
	media-libs/jpeg
	media-libs/libpng
	dev-libs/libxml2
	x11-libs/pango

	>=x11-libs/gtk+-2.8
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.25
	>=dev-db/sqlite-3

	gstreamer? ( >=media-libs/gst-plugins-base-0.10 )"

DEPEND="${RDEPEND}
	dev-util/gperf
	dev-util/pkgconfig
	virtual/perl-Text-Balanced"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	local myconf
	myconf="${myconf} --with-font-backend=pango"

	econf \
		$(use_enable gnome-keyring gnomekeyring) \
		$(use_enable gstreamer video) \
		$(use_enable svg) \
		$(use_enable debug) \
		$(use_enable coverage) \
		${myconf}

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
