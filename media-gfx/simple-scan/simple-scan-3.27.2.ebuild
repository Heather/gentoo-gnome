# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 vala versionator meson

DESCRIPTION="Simple document scanning utility"
HOMEPAGE="https://launchpad.net/simple-scan"

#MY_PV=$(get_version_component_range 1-2)
SRC_URI="https://git.gnome.org/browse/${PN}/snapshot/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="colord" # packagekit

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	dev-libs/libgusb[vala]
	>=media-gfx/sane-backends-1.0.20:=
	>=sys-libs/zlib-1.2.3.1:=
	virtual/jpeg:0=
	x11-libs/cairo:=
	>=x11-libs/gtk+-3:3
	colord? ( >=x11-misc/colord-0.1.24:=[udev] )
"
# packagekit? ( app-admin/packagekit-base )
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/0001-meson-allow-disabling-colord.patch
	default
}

src_configure() {
	local emesonargs=(
		-Dcolord=$(usex colord true false)
		-Dpackagekit=false
	)
	meson_src_configure
}
