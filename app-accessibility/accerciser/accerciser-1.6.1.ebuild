# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"

inherit gnome2 python

DESCRIPTION="Interactive Python accessibility explorer"
HOMEPAGE="http://live.gnome.org/Accerciser"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS="AUTHORS COPYING ChangeLog NEWS README"

RDEPEND=">=dev-lang/python-2.4
	dev-python/ipython
	dev-python/pygtk
	dev-python/pygobject
	dev-python/pycairo
	dev-python/libgnome-python
	dev-python/libwnck-python
	dev-python/gtksourceview-python
	dev-python/gconf-python
	dev-python/librsvg-python
	>=gnome-extra/at-spi-1.7
	>=dev-libs/glib-2"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.12"

pkg_setup() {
	G2CONF="${G2CONF} --without-pyreqs"
}

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_need_rebuild
	python_mod_optimize "$(python_get_sitedir)/accerciser"
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/accerciser
}
