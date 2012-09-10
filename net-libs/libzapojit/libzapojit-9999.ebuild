# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GLib/GObject wrapper for the SkyDrive and Hotmail REST APIs"
HOMEPAGE="http://git.gnome.org/browse/libzapojit"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc +introspection"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/libsoup-2.38:2.4
	dev-libs/json-glib
	net-libs/rest
	net-libs/gnome-online-accounts

	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	gnome-base/gnome-common:3
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.11 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-compile-warnings=minimum
		--disable-maintainer-mode
		--disable-static
		$(use_enable introspection)"
	DOCS="AUTHORS ChangeLog NEWS README"
}
