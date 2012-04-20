# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="System log viewer for GNOME 3"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
fi

COMMON_DEPEND=">=dev-libs/glib-2.31.0:2
	>=x11-libs/gtk+-3.0.0:3
	
	gnome-base/libgtop:2"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.22
	>=sys-devel/gettext-0.17"

pkg_setup() {
	DOCS="NEWS TODO"
	G2CONF="--disable-schemas-compile
		--enable-zlib"
}
