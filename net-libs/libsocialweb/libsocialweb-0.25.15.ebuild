# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit gnome2 python

DESCRIPTION="Social web services integration framework"
HOMEPAGE="http://git.gnome.org/browse/libsocialweb"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc connman +gnome +introspection +networkmanager vala"

# XXX: coverage testing should not be enabled
RDEPEND=">=dev-libs/glib-2.14:2
	>=net-libs/rest-0.7.1

	gnome-base/gconf:2
	gnome-base/libgnome-keyring
	dev-libs/dbus-glib
	dev-libs/json-glib
	net-libs/libsoup:2.4

	gnome? ( >=net-libs/libsoup-gnome-2.25.1:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
	networkmanager? ( net-misc/networkmanager )
	!networkmanager? ( connman? ( net-misc/connman ) )"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext
	doc? (
		dev-libs/libxslt
		>=dev-util/gtk-doc-1.15 )
	vala? (
		>=dev-lang/vala-0.10.0:0.12[vapigen]
		>=dev-libs/gobject-introspection-0.9.6 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-gcov
		--enable-all-services
		$(use_enable introspection)
		$(use_enable vala vala-bindings)
		$(use_with gnome)
		VALAC=$(type -P valac-0.12)
		VAPIGEN=$(type -P vapigen-0.12)
		--with-online=always"

	# NetworkManager always overrides connman support
	use connman && G2CONF="${G2CONF} --with-online=connman"
	use networkmanager && G2CONF="${G2CONF} --with-online=networkmanager"

	# Introspection is needed for vala bindings
	if use vala && ! use introspection; then
		ewarn "Introspection support is needed for Vala bindings, auto-enabling..."
		G2CONF="${G2CONF} --enable-introspection"
	fi

	DOCS="AUTHORS README TODO"

	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare

	python_convert_shebangs 2 ${S}/tools/glib-ginterface-gen.py
}
