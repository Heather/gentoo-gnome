# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.40

inherit gnome2-utils meson vala xdg-utils

DESCRIPTION="Code editor designed for elementary OS"
HOMEPAGE="https://github.com/elementary/code"
SRC_URI="https://github.com/elementary/code/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="nls plugins zeitgeist"

DEPEND="
	>=dev-lang/vala-0.40
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	app-text/editorconfig-core-c
	app-text/gtkspell:3
	>=dev-libs/glib-2.30:2
	>=dev-libs/granite-5.1.0
	>=dev-libs/libgee-0.8.5:0.8
	dev-libs/libgit2-glib
	dev-libs/libpeas[gtk]
	zeitgeist? ( gnome-extra/zeitgeist )
	media-libs/fontconfig
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4
	>=x11-libs/gtk+-3.6:3
	>=x11-libs/gtksourceview-3.24:3.0
	x11-libs/vte:2.91
"

S="${WORKDIR}/code-${PV}"

src_prepare() {
	eapply_user
	vala_src_prepare --vala-api-version 0.40
}

src_configure() {
	local emesonargs=(
		-Dplugins=$(usex plugins true false)
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
