# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit gnome2

DESCRIPTION="GNOME miners for crawling through online content"
HOMEPAGE="https://git.gnome.org/browse/gnome-online-miners"

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/libgdata-0.13.3:0/13
	>=dev-libs/glib-2.35.1:2
	>=net-libs/gnome-online-accounts-3.2.0
	>=media-libs/grilo-0.2.6:0.2
	>=net-libs/libzapojit-0.0.2
	>=app-misc/tracker-0.16:0/16
"
DEPEND="${RDEPEND}"
