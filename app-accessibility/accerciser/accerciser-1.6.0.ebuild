# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 python

DESCRIPTION="interactive Python accessibility explorer"
HOMEPAGE="http://live.gnome.org/Accerciser"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS="AUTHORS COPYING ChangeLog NEWS README"

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.8
	|| ( 
		>=dev-python/libbonobo-python-2.14
		>=dev-python/gnome-python-2.14 )
	>=dev-python/gnome-python-desktop-2.12
	>=dev-python/pyorbit-2.14
	>=gnome-extra/at-spi-1.7
	>=dev-libs/glib-2
	>=gnome-base/gconf-2"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.12"

pkg_setup() {
	G2CONF="--without-pyreqs"
}

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_version
	python_mod_optimize	/usr/$(get_libdir)/python${PYVER}/site-packages/accerciser
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup	/usr/$(get_libdir)/python*/site-packages/accerciser
}
