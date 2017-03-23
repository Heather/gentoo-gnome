# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VALA_MIN_VERSION=0.26

inherit fdo-mime gnome2-utils vala cmake-utils

inherit bzr
EBZR_REPO_URI="lp:${PN}"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="A desktop-wide extension service"
HOMEPAGE="https://launchpad.net/contcactor"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

RDEPEND="
	x11-libs/granite
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)"

src_prepare() {
	eapply_user

	# Translations
	use nls || sed -i -e 's/add_subdirectory (po)//' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake-utils_src_configure
}
