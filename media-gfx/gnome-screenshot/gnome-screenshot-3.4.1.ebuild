# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-utils/gnome-utils-2.32.0-r1.ebuild,v 1.1 2010/12/04 18:08:10 pacho Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Screenshot utility for GNOME 3"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
fi

# libcanberra 0.26-r2 is needed for gtk+:3 fixes
COMMON_DEPEND=">=dev-libs/glib-2.31.0:2
	>=x11-libs/gtk+-3.0.3:3
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	>=media-libs/libcanberra-0.26-r2[gtk3]
	x11-libs/libXext
	x11-libs/libX11"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	x11-proto/xextproto
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	DOCS="NEWS"
}
