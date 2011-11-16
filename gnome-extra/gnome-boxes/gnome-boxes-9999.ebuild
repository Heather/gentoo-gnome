# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Simple GNOME 3 application to access remote or virtual systems"
HOMEPAGE="https://live.gnome.org/Design/Apps/Boxes"

LICENSE="LGPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=dev-libs/libxml2-2.7.8:2
	>=sys-fs/udev-167[gudev]
	>=dev-libs/glib-2.29.90:2
	>=dev-libs/gobject-introspection-0.9.6
	>=sys-libs/libosinfo-0.0.1
	>=app-emulation/libvirt-glib-0.0.1
	>=x11-libs/gtk+-3.2.2-r1:3
	>=net-libs/gtk-vnc-0.4.4[gtk3]
	>=net-misc/spice-gtk-0.7.81[gtk3]"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17"

if [[ ${PV} = 9999 ]]; then
	# NOTE: There's been no release yet, so we're not sure if upstream will ship
	# with the C sources pregenerated from the vala source files or not.
	# Move these deps outside if that doesn't happen.
	DEPEND="${DEPEND}
		>=dev-lang/vala-0.14.0:0.14
		>=sys-libs/libosinfo-0.0.1[introspection,vala]
		>=app-emulation/libvirt-glib-0.0.1[introspection,vala]
		>=net-libs/gtk-vnc-0.4.4[gtk3,introspection,vala]
		>=net-misc/spice-gtk-0.7.1[introspection,vala]"
fi

pkg_setup() {
	DOCS="AUTHORS MAINTAINERS README TODO"
	G2CONF="--disable-schemas-compile
		--disable-strict-cc
		VALAC=$(type -P valac-0.14)"
}
