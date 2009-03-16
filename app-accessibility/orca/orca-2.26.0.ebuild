# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/orca/orca-2.24.4.ebuild,v 1.4 2009/03/11 01:50:43 dang Exp $

inherit gnome2 python

DESCRIPTION="Extensible screen reader that provides access to the desktop"
HOMEPAGE="http://www.gnome.org/projects/orca/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

# liblouis is not in portage yet
# it is used to provide contracted braille support
RDEPEND=">=dev-libs/glib-2.10
	>=gnome-base/orbit-2
	>=gnome-extra/at-spi-1.7.6
	>=gnome-base/libbonobo-2.14
	>=dev-lang/python-2.4
	>=dev-python/pygtk-2.12
	>=dev-python/gnome-python-2.14
	>=dev-python/pyorbit-2.14
	>=app-accessibility/gnome-speech-0.3.10
	>=app-accessibility/gnome-mag-0.12.5"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --disable-liblouis"
}

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/orca
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/orca
}
