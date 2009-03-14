# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-2.24.2.ebuild,v 1.1 2008/11/29 19:18:45 eva Exp $

inherit autotools eutils gnome2

DESCRIPTION="A versatile IDE for GNOME"
HOMEPAGE="http://www.anjuta.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="debug devhelp doc glade graphviz sourceview subversion valgrind"

RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.12.10
	>=gnome-base/orbit-2.6.0
	>=gnome-base/libglade-2.3.0
	>=gnome-base/libgnome-2.12.0
	>=gnome-base/libgnomeui-2.12.0
	>=gnome-base/gconf-2.12.0
	>=x11-libs/vte-0.13.1
	>=dev-libs/libxml2-2.4.23
	>=dev-libs/gdl-0.7.5
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-libs/gnome-build-0.3.0
	>=x11-libs/libwnck-2.12
	>=sys-devel/binutils-2.15.92
	>=dev-libs/unique-1.0.0

	dev-libs/libxslt
	dev-lang/perl
	sys-devel/autogen

	devhelp? ( >=dev-util/devhelp-0.22 )
	glade? ( >=dev-util/glade-3.5.7 )
	inherit-graph? ( >=media-gfx/graphviz-2.6.0 )
	sourceview? (
		>=x11-libs/gtk+-2.10.0
		>=gnome-base/libgnome-2.14.0
		>=x11-libs/gtksourceview-2.4.0 )
	subversion? (
		>=dev-util/subversion-1.5.0
		>=net-misc/neon-0.28.2
		>=dev-libs/apr-1
		>=dev-libs/apr-util-1 )
	valgrind? ( dev-util/valgrind )"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.14
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.20
	>=app-text/scrollkeeper-0.3.14-r2
	doc? ( >=dev-util/gtk-doc-1.0 )"

pkg_setup() {
	# symbol-db plugin depends on libgda-4
	G2CONF="${G2CONF} --disable-plugin-symbol-db
		$(use_enable debug)
		$(use_enable devhelp plugin-devhelp)
		$(use_enable glade plugin-glade)
		$(use_enable valgrind plugin-valgrind)
		$(use_enable sourceview plugin-sourceview)
		$(use_enable !sourceview plugin-scintilla)
		$(use_enable subversion plugin-subversion)
		$(use_enable graphviz)" # Toggles inherit-plugin and performance-plugin
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}/${P}-symbol-db-optional.patch"

	eautoreconf
}

src_install() {
	# Install user docs into /usr/share/doc/${PF}/
	sed -i -e "s:doc/${PN}:doc/${PF}:g" Makefile
	sed -i -e "s:doc/${PN}:doc/${PF}/html:g" doc/Makefile

	gnome2_src_install
	prepalldocs
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebeep 1
	elog "Some project templates may require additional development"
	elog "libraries to function correctly. It goes beyond the scope"
	elog "of this ebuild to provide them."
	epause 5
}
