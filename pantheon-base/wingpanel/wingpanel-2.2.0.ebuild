# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.24

inherit cmake-utils gnome2-utils vala xdg-utils

DESCRIPTION="Stylish top panel that holds indicators and spawns an application launcher"
HOMEPAGE="https://github.com/elementary/wingpanel"
SRC_URI="https://github.com/elementary/wingpanel/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libgee:0.8
	dev-libs/granite
	>=x11-libs/gtk+-3.22:3
	x11-wm/gala
"
DEPEND="${RDEPEND}
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

src_prepare() {
	eapply_user

	use nls || cmake_comment_add_subdirectory po

	# respect appropriate libdir for gala plugins
	[[ $(get_libdir) == lib ]] || \
		sed -e "s|/lib|/$(get_libdir)|g" \
			-i wingpanel-interface/CMakeLists.txt || die

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE=${VALAC}
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_schemas_update
}
