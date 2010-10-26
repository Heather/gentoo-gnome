# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcanberra/libcanberra-0.25.ebuild,v 1.1 2010/06/18 10:11:15 pacho Exp $

EAPI="3"
inherit gnome2-utils libtool

DESCRIPTION="Portable Sound Event Library"
HOMEPAGE="http://0pointer.de/lennart/projects/libcanberra/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="alsa gstreamer +gtk +gtk3 oss pulseaudio +sound tdb"

COMMON_DEPEND="media-libs/libvorbis
	>=sys-devel/libtool-2.2.6b
	alsa? ( media-libs/alsa-lib )
	gstreamer? ( >=media-libs/gstreamer-0.10.15 )
	gtk? ( >=x11-libs/gtk+-2.20.0:2
		>=gnome-base/gconf-2 )
	gtk3? ( x11-libs/gtk+:3
		>=gnome-base/gconf-2 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.11 )
	tdb? ( sys-libs/tdb )"
RDEPEND="${COMMON_DEPEND}
	sound? ( x11-themes/sound-theme-freedesktop )" # Required for index.theme wrt #323379
DEPEND="${COMMON_DEPEND}
	>=dev-util/pkgconfig-0.17"

src_prepare() {
	# Run elibtoolize for ~x86-fbsd.
	use x86-fbsd && elibtoolize
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-dependency-tracking \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable pulseaudio pulse) \
		$(use_enable gstreamer) \
		$(use_enable gtk) \
		$(use_enable gtk3) \
		$(use_enable tdb) \
		--disable-lynx \
		--disable-gtk-doc \
		--disable-gtk-doc-html \
		--disable-gtk-doc-pdf \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	# Disable parallel installation until bug #253862 is solved
	emake -j1 DESTDIR="${ED}" install || die
	prepalldocs
}

pkg_preinst() { gnome2_gconf_savelist; }
pkg_postinst() { gnome2_gconf_install; }
