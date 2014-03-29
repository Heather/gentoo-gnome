# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools gnome2

DESCRIPTION="Library for handling media art"
HOMEPAGE="http://www.gnome.org/pub/gnome/sources/libmediaart/0.3/"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/libmediaart/0.3/${P}.tar.xz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="x11-libs/gdk-pixbuf"

RDEPEND="${DEPEND}"

src_configure() {
        gnome2_src_configure
}

src_install() {
        gnome2_src_install
}
