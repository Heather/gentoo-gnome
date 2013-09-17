# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils

DESCRIPTION="A toolkit to assist in profiling applications in a domain specific way"
HOMEPAGE="https://github.com/rib/UProf"
SRC_URI="https://github.com/rib/UProf/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 mips ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib
	dev-libs/dbus-glib
	sys-libs/ncurses"
DEPEND="${RDEPEND}"

S="${WORKDIR}/UProf-${PV}"

AUTOTOOLS_IN_SOURCE_BUILD=1
MAKEOPTS+=" -j1"

src_prepare() {
	epatch "${FILESDIR}/disable-tests.patch"
	autotools-utils_autoreconf
	autotools-utils_src_prepare
}
