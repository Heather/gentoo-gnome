# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-calculator/gnome-calculator-3.8.2.ebuild,v 1.3 2013/06/30 21:34:06 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://live.gnome.org/Calculator"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

COMMON_DEPEND="
	>=x11-libs/gtk+-3:3
	>=dev-libs/glib-2.31:2
	dev-libs/libxml2:2
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gnome-utils-2.3
	!gnome-extra/gcalctool
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		ITSTOOL=$(type -P true) \
		VALAC=$(type -P true)
}
