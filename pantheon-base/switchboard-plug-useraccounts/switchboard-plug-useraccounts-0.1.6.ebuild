# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.34

inherit cmake-utils vala

DESCRIPTION="Switchboard plug to show system information."
HOMEPAGE="https://github.com/elementary/switchboard-plug-useraccounts"
SRC_URI="https://github.com/elementary/switchboard-plug-useraccounts/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls"

RDEPEND="
	dev-libs/granite
	dev-libs/libgee:0.8
	dev-libs/libpwquality
	gnome-base/gnome-desktop:3
	pantheon-base/switchboard
	sys-apps/accountsservice
	sys-auth/polkit
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

src_prepare() {
	use nls || sed -i '/add_subdirectory (po)/d' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}
