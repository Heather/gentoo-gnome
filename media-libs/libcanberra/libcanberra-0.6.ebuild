# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="Portable Sound Event API"
HOMEPAGE="https://tango.0pointer.de/pipermail/libcanberra-discuss/"
SRC_URI="http://0pointer.de/public/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa doc gtk pulseaudio"

RDEPEND="media-libs/libvorbis
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.11 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.17
	  sys-devel/libtool
	doc? ( >=dev-util/gtk-doc-1.9 )"

src_compile() {
	econf \
		$(use_enable alsa) \
		$(use_enable gtk) \
		$(use_enable pulseaudio pulse) \
		$(use_enable doc gtk-doc)

	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	dodoc README
}
