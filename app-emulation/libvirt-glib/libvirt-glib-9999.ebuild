# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit python gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GLib and GObject mappings for libvirt"
HOMEPAGE="http://libvirt.org/git/?p=libvirt-glib.git"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://libvirt.org/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="ftp://libvirt.org/libvirt/glib/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
IUSE="doc +introspection python +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-libs/libxml2:2
	>=app-emulation/libvirt-0.9.4
	>=dev-libs/glib-2.10:2
	introspection? ( >=dev-libs/gobject-introspection-0.10.8 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.10 )
	vala? ( dev-lang/vala:0.14 )"

pkg_setup() {
	# NEWS, ChangeLog, are empty in git
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="--disable-test-coverage
		VAPIGEN=$(type -P vapigen-0.14)
		$(use_enable introspection)
		$(use_enable vala)
		$(use_with python)"

	python_set_active_version 2
	python_pkg_setup
}
