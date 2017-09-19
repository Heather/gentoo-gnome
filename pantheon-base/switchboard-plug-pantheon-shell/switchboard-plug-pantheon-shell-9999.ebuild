# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VALA_MIN_API_VERSION=0.20

inherit vala cmake-utils git-r3

EGIT_REPO_URI="https://github.com/elementary/switchboard-plug-pantheon-shell.git"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="Configure the Pantheon desktop environment using Switchboard"
HOMEPAGE="http://launchpad.net/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

RDEPEND="
	dev-libs/granite
	>=pantheon-base/switchboard-2"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	use nls || sed -i '/add_subdirectory (po)/d' CMakeLists.txt

	addwrite /usr/share/glib-2.0/schemas/

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}
