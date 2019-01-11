# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.34

inherit cmake-utils gnome2-utils vala

DESCRIPTION="Adjust Locale settings using Switchboard."
HOMEPAGE="https://github.com/elementary/switchboard-plug-locale"
SRC_URI="https://github.com/elementary/switchboard-plug-locale/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls"

RDEPEND="
	app-i18n/ibus[vala]
	dev-libs/glib:2
	dev-libs/granite
	gnome-base/gnome-desktop:3
	pantheon-base/switchboard
	sys-auth/polkit
	sys-apps/accountsservice
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

src_prepare() {
	use nls || cmake_comment_add_subdirectory po

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

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
