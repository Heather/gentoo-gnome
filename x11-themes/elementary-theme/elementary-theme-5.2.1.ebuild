# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="The Gtk+ Stylesheet for elementary OS"
HOMEPAGE="https://github.com/elementary/stylesheet"
SRC_URI="https://github.com/elementary/stylesheet/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/stylesheet-${PV}"
