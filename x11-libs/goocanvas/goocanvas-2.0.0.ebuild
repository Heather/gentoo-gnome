# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/goocanvas/goocanvas-1.0.0.ebuild,v 1.1 2011/02/22 22:33:38 eva Exp $

EAPI="3"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Canvas widget for GTK+ using the cairo 2D library for drawing"
HOMEPAGE="http://live.gnome.org/GooCanvas"

LICENSE="GPL-2"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples"

RDEPEND=">=x11-libs/gtk+-3.0.0:3
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/cairo-1.10.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.8 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"
G2CONF="${G2CONF} --disable-rebuilds --disable-static"

src_install() {
	gnome2_src_install

	if use examples; then
		insinto "/usr/share/doc/${P}/examples/"
		doins demo/*.[ch] demo/*.png
	fi
}
