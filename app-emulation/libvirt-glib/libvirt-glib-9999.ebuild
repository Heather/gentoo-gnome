# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
EGIT_REPO_URI="git://libvirt.org/libvirt-glib.git"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GLib and GObject mappings for libvirt"
HOMEPAGE="http://libvirt.org/git/?p=libvirt-glib.git"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="doc +introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-libs/libxml2:2
	>=app-emulation/libvirt-0.9.4
	>=dev-libs/glib-2.10:2
	introspection? ( >=dev-libs/gobject-introspection-0.10.8 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.10 )
	vala? ( dev-lang/vala:0.14 )"

pkg_setup() {
	# NEWS, ChangeLog, are empty in git
	# README is empty
	DOCS="AUTHORS ChangeLog HACKING NEWS"
	# TODO: use_with python when python.eclass is fixed
	G2CONF="--disable-test-coverage
		--without-python
		VAPIGEN=$(type -P vapigen-0.14)
		$(use_enable introspection)
		$(use_enable vala)"
}

src_prepare() {
	gnome2_src_prepare
}
