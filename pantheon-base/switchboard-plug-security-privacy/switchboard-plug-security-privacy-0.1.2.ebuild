# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.22

inherit cmake-utils gnome2-utils vala

DESCRIPTION="Configure various aspects of the security of the system."
HOMEPAGE="https://github.com/elementary/switchboard-plug-security-privacy"
SRC_URI="https://github.com/elementary/switchboard-plug-security-privacy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/granite
	gnome-extra/zeitgeist
	pantheon-base/switchboard
	sys-auth/polkit
	x11-libs/gtk+:3
	x11-misc/light-locker
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
		-DGSETTINGS_COMPILE=OFF
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
