# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-media/gnome-media-2.30.0-r1.ebuild,v 1.1 2010/06/13 19:14:28 pacho Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit eutils gnome2 autotools

DESCRIPTION="Multimedia related programs for the GNOME desktop"
HOMEPAGE="http://ronald.bitfreak.net/gnome-media.php"

LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="pulseaudio"

RDEPEND=">=dev-libs/glib-2.18.2:2
	x11-libs/gtk+:3
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2.6.1
	>=gnome-base/gnome-control-center-2.31.5
	>=media-libs/gstreamer-0.10.23
	>=media-libs/gst-plugins-base-0.10.23
	>=media-libs/gst-plugins-good-0.10

	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	>=media-libs/libcanberra-0.13[gtk3]
	dev-libs/libxml2
	>=media-libs/gst-plugins-base-0.10.23:0.10
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-gconf-0.10.1
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/intltool-0.35.0"

DOCS="AUTHORS ChangeLog* NEWS MAINTAINERS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-scrollkeeper
		--disable-schemas-install
		--enable-gstprops
		--enable-grecord
		--enable-profiles
		$(use_enable pulseaudio)
		$(use_enable !pulseaudio gstmix)"
}

src_prepare() {
	gnome2_src_prepare

	# Don't use libunique (use GApplication instead)
	epatch "${FILESDIR}"/${P}-remove-libunique-dep.patch

	# Run the correct command from the panel applet
	epatch "${FILESDIR}"/${P}-use-correct-command.patch

	eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst
	ewarn
	ewarn "If you cannot play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
	if use pulseaudio; then
		ewarn "You have enabled pulseaudio support, gstmixer will not be built"
		ewarn "If you do not use pulseaudio, you do not want this"
	fi
}
