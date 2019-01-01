# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils meson vala xdg-utils

DESCRIPTION="A music player for listening to local music files, online radios, and Audio CD"
HOMEPAGE="http://anufrij.org/melody"
SRC_URI="https://github.com/artemanufrij/playmymusic/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls"

DEPEND="
	dev-lang/vala
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/granite
	dev-libs/json-glib
	media-libs/gst-plugins-base
	media-libs/taglib
	media-plugins/gst-plugins-meta[mp3]
	net-libs/libsoup:2.4
	x11-libs/gtk+:3
"

S="${WORKDIR}/playmymusic-${PV}"

src_prepare() {
	eapply_user
	epatch "${FILESDIR}/2.2.0-const.patch"
	epatch "${FILESDIR}/2.2.0-desktop_name.patch"
	vala_src_prepare
}

src_configure() {
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
