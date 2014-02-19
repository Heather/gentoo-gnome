# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnl/libnl-3.2.9999.ebuild,v 1.1 2013/10/23 10:58:30 jer Exp $

EAPI=5
inherit autotools git-r3

DESCRIPTION="Library for Neighbor Discovery Protocol"
HOMEPAGE="https://github.com/jpirko/libndp"
EGIT_REPO_URI="https://github.com/jpirko/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
eautoreconf
}
