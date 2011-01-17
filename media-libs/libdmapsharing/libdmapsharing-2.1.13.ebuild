# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base

DESCRIPTION="A library that implements the DMAP family of protocols"
HOMEPAGE="http://www.flyn.org/projects/libdmapsharing"
SRC_URI="http://www.flyn.org/projects/${PN}/${P}.tar.gz"

LICENSE=""
SLOT="2.2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/glib:2
	>=net-dns/avahi-0.6
	>=net-libs/libsoup-2.32:2.4
	>=media-libs/gstreamer-0.10
	>=media-libs/gst-plugins-base-0.10.24
	sys-libs/zlib
	|| (
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )
"

src_prepare() {
	base_src_prepare

	# Fix documentation sloting
	sed "s/^\(DOC_MODULE\).*/\1 = ${PN}-${SLOT}/" \
		-i docs/Makefile.am docs/Makefile.in || die "sed failed"
}

src_configure() {
	econf --with-mdns=avahi $(use_enable doc gtk-doc)
}

src_install() {
	base_src_install
	find "${ED}" -name "*.la" -delete || die "la file removal failed"
}
