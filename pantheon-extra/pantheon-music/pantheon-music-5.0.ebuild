# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.40

DESCRIPTION="Elementary OS music player"
HOMEPAGE="https://github.com/elementary/music"
SRC_URI="https://github.com/elementary/music/archive/5.0.tar.gz -> ${P}.tar.gz"

inherit gnome2-utils meson vala xdg-utils

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="nls plugins ipod"

DEPEND="
	dev-lang/vala:0.40
	nls? ( sys-devel/gettext )
	virtual/pkgconfig	
"

RDEPEND="${DEPEND}
	dev-libs/dbus-glib
	>=dev-libs/glib-2.39:2
	dev-libs/granite
	dev-libs/json-glib
	dev-libs/libgee:0.8
	dev-libs/libpeas[gtk]
	dev-libs/libxml2
	gnome-extra/libgda:5
	gnome-extra/zeitgeist
	media-libs/clutter-gtk
	media-libs/gst-plugins-base
	media-libs/gstreamer
	ipod? ( media-libs/libgpod )
	media-libs/taglib
	media-plugins/gst-plugins-meta[mp3]
	net-libs/libaccounts-glib
	net-libs/libsoup:2.4
	>=x11-libs/gtk+-3.22:3
	x11-libs/libnotify
"

S="${WORKDIR}/music-${PV}"

src_prepare() {
	eapply_user

	vala_src_prepare --vala-api-version 0.40
}

src_configure() {
	local plugs="[ 'audioplayer'"
	if [ $(usex ipod true false ) = true ]; then
		plugs=$plugs", 'ipod'"
	fi
	plugs=$plugs" ]"
	local emesonargs=(
		-D'build-plugins'=$(usex plugins true false)
		-Dplugins="$plugs"			
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
