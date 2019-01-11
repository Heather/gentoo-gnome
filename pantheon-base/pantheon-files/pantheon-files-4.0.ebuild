# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.40

inherit cmake-utils gnome2-utils vala xdg-utils

DESCRIPTION="A simple, powerful, sexy file manager for the Pantheon desktop"
HOMEPAGE="https://github.com/elementary/files"
SRC_URI="https://github.com/elementary/files/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~x86 amd64"

LICENSE="GPL-3"
SLOT="0"
IUSE="+gvfs nls"

DEPEND="
	>=dev-lang/vala-0.40
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	dev-db/sqlite:3
	dev-libs/dbus-glib
	>=dev-libs/glib-2.32.0:2
	>=dev-libs/granite-5.0.0
	dev-libs/libgee:0.8
	gvfs? ( gnome-base/gvfs )
	gnome-extra/zeitgeist
	>=media-libs/libcanberra-0.30
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libnotify-0.7.2
	>=x11-libs/pango-1.1.2
	x11-misc/plank
	=xfce-extra/tumbler-0.2.1
"

S="${WORKDIR}/files-${PV}"

src_prepare() {
	eapply_user
	use nls || cmake_comment_add_subdirectory po
	cmake-utils_src_prepare
	vala_src_prepare --vala-api-version 0.40
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DWITH_UNITY=OFF
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
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
}
