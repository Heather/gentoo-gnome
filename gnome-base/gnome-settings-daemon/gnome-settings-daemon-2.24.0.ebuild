# Copyright 2008-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-settings-daemon/gnome-settings-daemon-2.22.1.ebuild,v 1.1 2008/04/07 21:39:13 eva Exp $

inherit autotools eutils gnome2

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="alsa debug esd gstreamer libnotify pulseaudio"

RDEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.18.0
	>=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2.6.1
	>=gnome-base/libgnomekbd-2.21.4
	
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gnome-desktop-2.23.90
	
	libnotify? ( >=x11-libs/libnotify-0.4.3 )
	
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-3.3
	media-libs/fontconfig
	
	esd? ( >=media-sound/esound-0.2.28 )
	gstreamer? (
		>=media-libs/gstreamer-0.10.1.2
		>=media-libs/gst-plugins-base-0.10.1.2 )
	!gstreamer? (
		alsa? ( >=media-libs/alsa-lib-0.99 ) )"
# In configure: gstreamer wins over alsa

DEPEND="${RDEPEND}
	!<gnome-base/gnome-control-center-2.22
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	x11-proto/inputproto
	x11-proto/xproto"

# pulseaudio is used to detect if system should build
# old sound preference capplet (some braindead logic in there)
PDEPEND="pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable alsa)
		$(use_enable debug)
		$(use_enable esd)
		$(use_enable gstreamer)
		$(use_enable libnotify)
		$(use_enable pulseaudio libpulse)"
}

src_unpack() {
	gnome2_src_unpack

	# Fix libnotify & pulseaudio automagic dependencies
	epatch "${FILESDIR}/${P}-automagic.patch"

	eautoreconf
}
