# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit db-use eutils flag-o-matic gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Evolution module for connecting to Exchange Web Services"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE="" # doc

RDEPEND=">=mail-client/evolution-${PV}:2.0
	>=gnome-extra/evolution-data-server-${PV}
	>=dev-libs/glib-2.26
	>=dev-libs/libxml2-2
	>=gnome-base/gconf-2:2
	>=net-libs/libsoup-2.30:2.4
	>=x11-libs/gtk+-2.90.4:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	>=dev-util/pkgconfig-0.16
"
# For now, this package has no gtk-doc documentation to build
#	doc? ( >=dev-util/gtk-doc-1.9 )

RESTRICT="test" # tests require connecting to an Exchange server

pkg_setup() {
	DOCS="ChangeLog NEWS README" # AUTHORS is empty
}
