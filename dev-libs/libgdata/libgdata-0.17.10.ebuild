# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"
GNOME2_EAUTORECONF="yes"

inherit gnome2 vala meson

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="https://wiki.gnome.org/Projects/libgdata"

LICENSE="LGPL-2.1+"
SLOT="0/22" # subslot = libgdata soname version

IUSE="+crypt gnome-online-accounts +introspection static-libs test vala"
REQUIRED_USE="
	gnome-online-accounts? ( crypt )
	vala? ( introspection )
"

KEYWORDS="alpha amd64 ~arm arm64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	net-libs/uhttpmock
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/json-glib-0.15[introspection?]
	>=dev-libs/libxml2-2:2
	>=net-libs/liboauth-0.9.4
	>=net-libs/libsoup-2.55.90:2.4[introspection?]
	>=x11-libs/gdk-pixbuf-2.14:2
	crypt? ( app-crypt/gcr:= )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:=[introspection?,vala?] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	virtual/pkgconfig
	test? ( >=net-libs/uhttpmock-0.5 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	default
}

