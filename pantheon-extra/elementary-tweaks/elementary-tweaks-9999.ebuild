# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.22

inherit cmake-utils git-r3 gnome2-utils vala

DESCRIPTION="Elementary OS customization tool"
HOMEPAGE="https://github.com/elementary-tweaks"
EGIT_REPO_URI="https://github.com/elementary-tweaks/elementary-tweaks.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls"

DEPEND="
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	dev-libs/glib:2
	dev-libs/granite
	dev-libs/libgee:0.8
	gnome-base/gconf:2
	pantheon-base/switchboard
	sys-auth/polkit
	x11-libs/gtk+:3
"

src_prepare() {
	use nls || cmake_comment_add_subdirectory po

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
