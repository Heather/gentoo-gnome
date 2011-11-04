# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="threads"
# FIXME: multiple python support

inherit gnome2 python

DESCRIPTION="Extensible screen reader that provides access to the desktop"
HOMEPAGE="http://projects.gnome.org/orca/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

# liblouis is not in portage yet
# it is used to provide contracted braille support
# XXX: Check deps for correctness
COMMON_DEPEND=">=app-accessibility/at-spi2-core-2.1.5:2
	>=dev-libs/glib-2.28:2
	>=dev-python/pygobject-2.90.3:3
	>=x11-libs/gtk+-3.1.13:3[introspection]"
RDEPEND="${COMMON_DEPEND}
	app-accessibility/speech-dispatcher
	dev-libs/atk[introspection]
	>=dev-python/dbus-python-0.83
	dev-python/pyatspi
	dev-python/pyxdg
	x11-libs/libwnck:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize "${PN}"
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup "${PN}"
}
