# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2

DESCRIPTION="A map application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Maps"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.38.0
	>=dev-libs/gjs-1.38.0
	>=media-libs/libchamplain-0.12.5
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"

MAKEOPTS+=" -j1" # install broken with -jN
