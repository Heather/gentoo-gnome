# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-media/gnome-media-2.24.0.1-r1.ebuild,v 1.1 2009/02/07 12:10:03 ford_prefect Exp $

EAPI="1"

inherit autotools eutils gnome2

DESCRIPTION="Multimedia related programs for the GNOME desktop"
HOMEPAGE="http://ronald.bitfreak.net/gnome-media.php"

LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="esd gnomecd ipv6 pulseaudio"

RDEPEND=">=dev-libs/glib-2.18.2:2
	>=gnome-base/libgnomeui-2.13.2
	esd? ( >=media-sound/esound-0.2.23 )
	>=x11-libs/gtk+-2.10:2
	>=media-libs/gstreamer-0.10.3
	>=media-libs/gst-plugins-base-0.10.3
	>=media-libs/gst-plugins-good-0.10
	>=gnome-base/orbit-2
	>=media-libs/libcanberra-0.4
	gnomecd? (
		>=gnome-extra/nautilus-cd-burner-2.12
		>=gnome-base/gail-0.0.3
		>=gnome-base/libbonobo-2
		|| (
			>=media-plugins/gst-plugins-cdio-0.10
			>=media-plugins/gst-plugins-cdparanoia-0.10 ) )
	pulseaudio? (
		>=media-sound/pulseaudio-0.9.12 )
	>=gnome-base/libglade-2
	dev-libs/libxml2
	>=gnome-base/gconf-2.6.1
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-gconf-0.10.1"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35.0"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-gstprops
		--disable-esdtest
		--disable-scrollkeeper
		--disable-schemas-install
		$(use_enable esd esound)
		$(use_enable esd vumeter)
		$(use_enable gnomecd cddbslave)
		$(use_enable gnomecd)
		$(use_enable ipv6)
		$(use_enable debug more-warnings)
		$(use_enable pulseaudio)
		$(use_enable !pulseaudio gstmix)"
}

src_compile() {
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	gnome2_src_compile
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
