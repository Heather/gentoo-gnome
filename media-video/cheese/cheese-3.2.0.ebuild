# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cheese/cheese-2.32.0.ebuild,v 1.6 2011/02/24 20:36:45 tomka Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://www.gnome.org/projects/cheese/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc +introspection vala"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

COMMON_DEPEND="
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/libgee-0.6.0:0
	>=x11-libs/gtk+-2.99.4:3[introspection?]
	>=x11-libs/cairo-1.10
	>=x11-libs/pango-1.28.0
	|| ( >=sys-fs/udev-171[gudev] >=sys-fs/udev-145-r1[extras] )
	>=gnome-base/gnome-desktop-2.91.6:3
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=media-libs/clutter-1.6.1:1.0[introspection?]
	>=media-libs/clutter-gtk-0.91.8:1.0
	>=media-libs/clutter-gst-1.0.0:1.0

	media-video/gnome-video-effects
	x11-libs/gdk-pixbuf:2[jpeg,introspection?]
	x11-libs/mx
	x11-libs/libX11
	x11-libs/libXtst

	>=media-libs/gstreamer-0.10.32:0.10[introspection?]
	>=media-libs/gst-plugins-base-0.10.32:0.10[introspection?]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-bad-0.10.19
	>=media-libs/gst-plugins-good-0.10.16
	>=media-plugins/gst-plugins-ogg-0.10.20
	>=media-plugins/gst-plugins-pango-0.10.20
	>=media-plugins/gst-plugins-theora-0.10.20
	>=media-plugins/gst-plugins-v4l2-0.10
	>=media-plugins/gst-plugins-vorbis-0.10.20
	|| ( >=media-plugins/gst-plugins-x-0.10
		>=media-plugins/gst-plugins-xvideo-0.10 )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/vala-0.11.6:0.12
	>=app-text/gnome-doc-utils-0.20
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	x11-proto/xf86vidmodeproto
	app-text/docbook-xml-dtd:4.3
	doc? ( >=dev-util/gtk-doc-1.14 )"

pkg_setup() {
	G2CONF="${G2CONF}
		VALAC=$(type -p valac-0.12)
		$(use_enable introspection)
		--disable-maintainer-mode
		--disable-scrollkeeper
		--disable-static"
	DOCS="AUTHORS ChangeLog NEWS README"
}
