# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools git-r3

DESCRIPTION="Library for handling media art"
HOMEPAGE="http://www.gnome.org"
EGIT_REPO_URI="https://github.com/GNOME/libmediaart"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
eautoreconf
}

