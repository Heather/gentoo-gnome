# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
MY_PN="gtk-theme-engine-clearlooks"

inherit gnome2

DESCRIPTION="GTK+3 Clearlooks Engine"
HOMEPAGE="http://www.gtk.org/"
SRC_URI="${SRC_URI//${PN}/${MY_PN}}"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.91.6:3"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog NEWS README"
S="${WORKDIR}/${MY_PN}-${PV}"

# XXX: Animation fails to compile, disable for now
G2CONF="${G2CONF}
--disable-maintainer-mode
--disable-animation
--disable-paranoia
--disable-deprecated"
