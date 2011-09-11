# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/ghex/ghex-2.24.0.ebuild,v 1.11 2011/01/24 13:12:44 eva Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Gnome hexadecimal editor"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1"
SLOT="3"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-3.0:3
	>=dev-libs/atk-1"
# File collisions with gtk2-based program's icons etc.
RDEPEND="${COMMON_DEPEND}
	!<app-editors/ghex-2.24.0-r200:2"
DEPEND="${COMMON_DEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.41.0
	>=app-text/gnome-doc-utils-0.9.0
	>=sys-devel/gettext-0.17"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static"
}
