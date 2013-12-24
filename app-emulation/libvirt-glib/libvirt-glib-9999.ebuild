# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.14"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit gnome2 python-single-r1 vala
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
IUSE="+introspection python +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-libs/libxml2:2
	>=app-emulation/libvirt-0.9.10:=
	>=dev-libs/glib-2.10:2
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-test-coverage \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_with python)
}
