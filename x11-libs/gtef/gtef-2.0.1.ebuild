# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="GTK+ Text Editor Framework"
HOMEPAGE="https://wiki.gnome.org/Projects/Gtef"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="$(vala_depend)
	>=dev-libs/glib-2.51.5
	>=dev-libs/gobject-introspection-1.42.0:=
	dev-libs/libxml2
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/gtksourceview-3.22:3.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-gvfs-metadata \
		--disable-installed-tests
}
