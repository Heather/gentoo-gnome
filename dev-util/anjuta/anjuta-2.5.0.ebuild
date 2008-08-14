# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-2.4.2.ebuild,v 1.3 2008/08/03 21:50:51 mabi Exp $

inherit eutils gnome2

DESCRIPTION="A versatile IDE for GNOME"
HOMEPAGE="http://www.anjuta.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="debug devhelp doc glade inherit-graph sourceview subversion valgrind"

RDEPEND=">=dev-libs/glib-2.14.0
		 >=x11-libs/gtk+-2.10.0
		 >=gnome-base/orbit-2.6.0
		 >=gnome-base/libglade-2.3.0
		 >=gnome-base/libgnome-2.12.0
		 >=gnome-base/libgnomeui-2.12.0
		 >=gnome-base/libgnomeprint-2.12.0
		 >=gnome-base/libgnomeprintui-2.12.0
		 >=gnome-base/gnome-vfs-2.12.0
		 >=gnome-base/gconf-2.12.0
		 >=x11-libs/vte-0.13.1
		 >=dev-libs/libxml2-2.4.23
		 >=x11-libs/pango-1.1.1
		 >=dev-libs/gdl-0.7.5
		 >=app-text/gnome-doc-utils-0.3.2
		 >=dev-libs/gnome-build-0.3.0
		 >=x11-libs/libwnck-2.12
		 >=sys-devel/binutils-2.15.92
		   dev-libs/libxslt
		   sys-devel/autogen
		 devhelp? ( >=dev-util/devhelp-0.13 )
		 glade? ( >=dev-util/glade-3.1.4 )
		 inherit-graph? ( >=media-gfx/graphviz-2.6.0 )
		 sourceview? (
						>=x11-libs/gtk+-2.10.0
						>=gnome-base/libgnome-2.14.0
						>=x11-libs/gtksourceview-2.1.2
					 )
		 subversion? (
						>=dev-util/subversion-1.1.4
						>=net-misc/neon-0.24.5
						dev-libs/apr
					 )
		 valgrind? ( dev-util/valgrind )"
DEPEND="${RDEPEND}
		  dev-lang/perl
		>=sys-devel/gettext-0.14
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.20
		>=app-text/scrollkeeper-0.3.14-r2
		doc? ( >=dev-util/gtk-doc-1.0 )"

pkg_setup() {
	# gtk-doc is handled by eclass
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable devhelp plugin-devhelp)
		$(use_enable glade plugin-glade)
		$(use_enable valgrind plugin-valgrind)
		$(use_enable sourceview plugin-sourceview)
		$(use_enable !sourceview plugin-scintilla)
		$(use_enable subversion plugin-subversion)
		$(use_enable inherit-graph plugin-class-inheritance)"
}

src_unpack() {
	gnome2_src_unpack

	# Patch to prevent an access violation (bug #164740)
	epatch "${FILESDIR}/${PN}-2.1.0-sandbox-fix.patch"

	# Fix documentation to pass tests, upstream bug #536889
	epatch "${FILESDIR}/${PN}-2.4.2-documentation.patch"
}

src_install() {
	# Install user docs into /usr/share/doc/${PF}/
	sed -i -e "s:doc/${PN}:doc/${PF}:g" Makefile
	sed -i -e "s:doc/${PN}:doc/${PF}/html:g" doc/Makefile

	# see Gnome Bug #527144 and Gentoo Bug #216898
	gnome2_src_install -j1
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
