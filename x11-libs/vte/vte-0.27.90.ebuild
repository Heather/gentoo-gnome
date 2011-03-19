# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.26.2.ebuild,v 1.1 2010/11/19 22:00:44 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="GNOME terminal widget"
HOMEPAGE="http://git.gnome.org/browse/vte"

LICENSE="LGPL-2"
SLOT="2.90"
IUSE="debug doc +introspection"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
fi

PDEPEND="x11-libs/gnome-pty-helper"
RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-3.0:3
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses
	x11-libs/libX11
	x11-libs/libXft

	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.13 )
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-apps/sed
	sys-devel/gettext"

src_prepare() {
	# Python bindings are via gobject-introspection
	# Ex: from gi.repository import Vte
	# Glade is disabled because it needs gladeui-1.0 & gtk3 glade is gladeui-2.0
	G2CONF="${G2CONF}
		--disable-glade-catalogue
		--disable-gnome-pty-helper
		--disable-deprecation
		--disable-maintainer-mode
		--disable-static
		$(use_enable debug)
		$(use_enable introspection)
		--with-html-dir=${ROOT}/usr/share/doc/${PF}/html
		--with-gtk=3.0"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	epatch "${FILESDIR}/${PN}-0.27.90-fix-gdk-targets.patch"

	[[ ${PV} != 9999 ]] && eautoreconf

	gnome2_src_prepare
}
