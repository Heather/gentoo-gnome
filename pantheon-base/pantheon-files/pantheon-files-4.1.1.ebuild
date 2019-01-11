# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.40

inherit gnome2-utils meson vala xdg-utils

DESCRIPTION="A simple, powerful, sexy file manager for the Pantheon desktop"
HOMEPAGE="https://github.com/elementary/files"
SRC_URI="https://github.com/elementary/files/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

DEPEND="
	>=dev-lang/vala-0.40
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	dev-db/sqlite:3
	dev-libs/dbus-glib
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/granite-5.2.0
	dev-libs/libgee:0.8
	gnome-extra/zeitgeist
	>=media-libs/libcanberra-0.30
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libnotify-0.7.2
	>=x11-libs/pango-1.1.2
	=xfce-extra/tumbler-0.2.1
"

S="${WORKDIR}/files-${PV}"

src_prepare() {
	eapply_user
	vala_src_prepare --vala-api-version 0.40
}

src_configure() {
	local emesonargs=(
		-Dwith-unity=false
	)
	meson_src_configure
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
