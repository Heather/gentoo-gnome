# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"

inherit gnome3

DESCRIPTION="GLib/GObject wrapper for the SkyDrive and Hotmail REST APIs"
HOMEPAGE="http://git.gnome.org/browse/libzapojit"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+introspection"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
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
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs:
#	gnome-base/gnome-common:3

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		gnome-base/gnome-common:3
		doc? ( >=dev-util/gtk-doc-1.11 )"
fi

src_configure() {
	gnome3_src_configure \
		--enable-compile-warnings=minimum \
		--disable-static \
		$(use_enable introspection)
}

src_install() {
	gnome3_src_install
	# Drop self-installed documentation
	rm -r "${ED}"/usr/share/doc/libzapojit/ || die
}
