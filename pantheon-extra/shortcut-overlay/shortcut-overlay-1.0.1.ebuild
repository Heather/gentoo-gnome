# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils meson vala

DESCRIPTION="A native OS-wide shortcut overlay to be launched by Gala"
HOMEPAGE="https://github.com/elementary/shortcut-overlay"
SRC_URI="https://github.com/elementary/shortcut-overlay/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
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
	x11-libs/gtk+:3
"


src_prepare() {
	eapply_user
	epatch "${FILESDIR}/shortcut-overlay-${PV}-oldmutter.patch"
	vala_src_prepare
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
