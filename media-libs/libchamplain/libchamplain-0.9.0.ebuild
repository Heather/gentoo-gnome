# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libchamplain/libchamplain-0.8.1.ebuild,v 1.1 2011/02/12 09:11:16 jlec Exp $

EAPI="3"

inherit gnome2

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="http://blog.pierlux.com/projects/libchamplain/en/"

LICENSE="LGPL-2"
SLOT="0.10"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gtk html +introspection"

RDEPEND="
	>=dev-libs/glib-2.16:2
	>=x11-libs/cairo-1.4
	>=media-libs/clutter-1.2:1.0
	>=media-libs/memphis-0.2.1:0.2
	>=net-libs/libsoup-gnome-2.4.1:2.4
	dev-db/sqlite:3
	gtk? (
		>=x11-libs/gtk+-2.90:3
		>=media-libs/clutter-gtk-0.90:1.0 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	gnome2_src_prepare

	# Vala demos try to use vala-0.8.0, do not want
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-maemo
		--disable-vala-demos
		--enable-memphis
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html"
		$(use_enable gtk)
		$(use_enable html gtk-doc-html)
		$(use_enable introspection)"

	#sed 's:bindings::g' -i Makefile.in || die
}
