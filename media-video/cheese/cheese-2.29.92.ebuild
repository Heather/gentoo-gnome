# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cheese/cheese-2.26.2.ebuild,v 1.1 2009/05/18 21:32:54 eva Exp $

GCONF_DEBUG="no"
EAPI=2

inherit gnome2 eutils

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://www.gnome.org/projects/cheese/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="v4l"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.7
	>=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.19.1
	>=x11-libs/cairo-1.4.0
	>=x11-libs/pango-1.18.0
	>=sys-apps/dbus-1
	>=sys-fs/udev-1
	>=gnome-base/gconf-2.16.0
	>=gnome-base/gnome-desktop-2.26
	>=gnome-base/librsvg-2.18.0
	>=media-libs/libcanberra-0.11[gtk]

	>=media-libs/gstreamer-0.10.23
	>=media-libs/gst-plugins-base-0.10.23"
RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-ogg-0.10.20
	>=media-plugins/gst-plugins-pango-0.10.20
	>=media-plugins/gst-plugins-theora-0.10.20
	>=media-plugins/gst-plugins-v4l2-0.10
	>=media-plugins/gst-plugins-vorbis-0.10.20
	v4l? ( >=media-plugins/gst-plugins-v4l-0.10 )"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	x11-proto/xf86vidmodeproto"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper --disable-hildon"
}
