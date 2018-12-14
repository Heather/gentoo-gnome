# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.40

inherit gnome2-utils meson vala xdg-utils

DESCRIPTION="Manage processes and monitor system resources."
HOMEPAGE="https://github.com/stsdc/monitor"
SRC_URI="https://github.com/stsdc/monitor/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls"

DEPEND="
	>=dev-lang/vala-0.40
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	dev-libs/glib:2
	dev-libs/granite
	dev-libs/libgee:0.8
	gnome-base/libgtop:2
	x11-libs/bamf
	x11-libs/gtk+:3
	x11-libs/libwnck:3
"

src_prepare() {
	eapply_user
	vala_src_prepare --vala-api-version 0.40
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
