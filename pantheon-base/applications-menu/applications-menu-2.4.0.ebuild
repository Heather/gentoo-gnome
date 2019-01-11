# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils vala

VALA_MIN_API_VERSION="0.32"

DESCRIPTION="A lightweight and stylish app launcher for Pantheon and other DEs"
HOMEPAGE="https://github.com/elementary/applications-menu"
SRC_URI="https://github.com/elementary/applications-menu/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="nls zeitgeist"

DEPEND="
	$(vala_depend)	
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	>=dev-libs/appstream-0.10.0[vala]
	dev-libs/glib:2
	>=dev-libs/granite-0.5
	dev-libs/json-glib
	dev-libs/libgee:0.8
	gnome-base/gnome-menus:3
	zeitgeist? ( gnome-extra/zeitgeist )
	net-libs/libsoup:2.4
	pantheon-base/switchboard
	pantheon-base/wingpanel
	>=x11-libs/gtk+-3.12.0:3
"

src_prepare() {
	eapply_user

	use nls || cmake_comment_add_subdirectory po

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DICONCACHE_UPDATE=OFF
		-DUSE_ZEITGEIST=$(usex zeitgeist ON OFF )
		-DUSE_UNITY=OFF
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
