# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="http://live.gnome.org/libgdata"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc gnome +introspection static-libs"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

# gtk+ is needed for gdk
# configure checks for gtk:3, but only uses it for demos which are not installed
RDEPEND=">=dev-libs/glib-2.31:2
	>=x11-libs/gdk-pixbuf-2.14:2
	>=dev-libs/libxml2-2:2
	>=net-libs/libsoup-2.37.91:2.4[introspection?]
	>=net-libs/liboauth-0.9.4

	app-crypt/gcr
	net-libs/gnome-online-accounts

	gnome? ( >=net-libs/libsoup-gnome-2.37.91:2.4[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.7 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.14 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="${G2CONF}
		$(use_enable static-libs static)
		$(use_enable gnome)
		$(use_enable introspection)"
}

src_prepare() {
	# Regenerate marshalers for <glib-2.31 compat
	rm -v gdata/gdata-marshal.{c,h} || die

	gnome2_src_prepare

	# Disable tests requiring network access, bug #307725
	sed -e '/^TEST_PROGS = / s:\(.*\):TEST_PROGS = general perf\nOLD_\1:' \
		-i gdata/tests/Makefile.in || die "network test disable failed"
}

src_test() {
	unset ORBIT_SOCKETDIR
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch emake check || die "emake check failed"
}

pkg_preinst() {
	gnome2_pkg_preinst
	preserve_old_lib /usr/$(get_libdir)/libgdata.so.7
	preserve_old_lib /usr/$(get_libdir)/libgdata.so.11
}

pkg_postinst() {
	gnome2_pkg_postinst
	preserve_old_lib_notify /usr/$(get_libdir)/libgdata.so.7
	preserve_old_lib_notify /usr/$(get_libdir)/libgdata.so.11
}
