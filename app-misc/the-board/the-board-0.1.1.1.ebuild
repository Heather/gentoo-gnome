# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit gnome2

DESCRIPTION="A space to place daily records"
HOMEPAGE="http://live.gnome.org/TheBoardProject"

# Not sure if this is the correct license
LICENSE="GPL-3"
SLOT="0"
IUSE="+libnotify +libsoup +nautilus"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=dev-libs/glib-2.27.3
	>=x11-libs/gtk+-2.91.7:3[introspection]
	>=x11-libs/gdk-pixbuf-2.22:2[introspection]
	>=dev-libs/gjs-0.7.7
	>=dev-libs/gobject-introspection-0.9.6
	>=media-libs/clutter-1.6.0:1.0[introspection]
	>=media-libs/clutter-gtk-0.91.8:1.0
	>=media-libs/clutter-gst-1.3.2:1.0
	>=x11-libs/mx-1.1.1[introspection]

	libnotify? ( >=x11-libs/libnotify-0.7.1 )
	libsoup? ( net-libs/libsoup:2.4[introspection] )
	nautilus? ( >=x11-libs/gdk-pixbuf-2.22.1
				>=gnome-base/nautilus-2.91.3 )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.40"

DOCS="AUTHORS NEWS README"

src_prepare() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-maintainer-mode
		$(use_with libnotify)
		$(use_with libsoup)
		$(use_with nautilus)"
	gnome2_src_prepare
}
