# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="python? 2:2.5"
inherit python gnome2

DESCRIPTION="A GObject plugins library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk python"

RDEPEND=">=dev-libs/glib-2.23.6:2
	>=dev-libs/gobject-introspection-0.9.0
	gtk? ( >=x11-libs/gtk+-2.90:3[introspection] )
	python? ( >=dev-python/pygobject-2.20 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	>=sys-devel/libtool-2.2.6
	doc? ( >=dev-util/gtk-doc-1.11 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable gtk libpeasui)
		$(use_enable python)
		--disable-maintainer-mode
		--disable-gtk2-test-build
		--disable-seed"
}
