# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/orca/orca-2.26.3.ebuild,v 1.1 2009/07/19 09:21:51 eva Exp $

GCONF_DEBUG="no"

inherit gnome2 python

DESCRIPTION="Extensible screen reader that provides access to the desktop"
HOMEPAGE="http://www.gnome.org/projects/orca/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

# liblouis is not in portage yet
# it is used to provide contracted braille support
RDEPEND=">=dev-libs/glib-2.10
	>=gnome-extra/at-spi-1.24
	>=gnome-base/orbit-2
	>=dev-python/pyorbit-2.24
	>=gnome-base/libbonobo-2.24
	>=dev-python/libbonobo-python-2.24

	>=dev-lang/python-2.4
	dev-python/pygobject
	dev-python/pycairo
	>=dev-python/dbus-python-0.83
	>=dev-python/pygtk-2.12

	>=dev-python/libwnck-python-2.24
	>=dev-python/gconf-python-2.24
	>=dev-python/libgnome-python-2.14

	>=app-accessibility/gnome-speech-0.3.10
	>=app-accessibility/gnome-mag-0.12.5"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed 2 failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize $(python_get_sitedir)/orca
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/orca
}
