# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/ghex/ghex-2.24.0.ebuild,v 1.11 2011/01/24 13:12:44 eva Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="Gnome hexadecimal editor library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.13:2
	dev-libs/popt
	>=dev-libs/atk-1
	gnome-base/gconf:2
	>=gnome-base/libgnomeui-2.6
	>=gnome-base/libgnomeprintui-2.2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2"
# Most people who install ghex will be looking to get a hex editor program
PDEPEND="app-editors/ghex:3"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF} --disable-static"
}

src_prepare() {
	# build only the gtkhex library; the executable will be provided by ghex:3
	epatch "${FILESDIR}/${P}-build-libgtkhex-only.patch"
	eautoreconf
	gnome2_src_prepare
}
