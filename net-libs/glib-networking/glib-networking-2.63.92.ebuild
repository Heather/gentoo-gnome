# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg multilib-minimal

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/${PN}"
SRC_URI="https://ftp.gnome.org/pub/GNOME/sources/${PN}/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gnome gnutls +libproxy libressl +openssl test ssl"
KEYWORDS="~amd64"

REQUIRED_USE="ssl? ( || ( gnutls openssl ) )"

DEPEND="
	>=dev-libs/glib-2.60:2[${MULTILIB_USEDEP}]
	libproxy? ( >=net-libs/libproxy-0.3.1:=[${MULTILIB_USEDEP}] )
	gnutls? ( >=net-libs/gnutls-3.4.6:=[${MULTILIB_USEDEP}] )
	openssl? (
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:=[${MULTILIB_USEDEP}] )
	)
"

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature gnutls)
		$(meson_feature openssl)
		$(meson_feature libproxy)
		$(meson_feature gnome gnome_proxy)
		-Dinstalled_tests=false
		-Dstatic_modules=false
	)

	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_test() {
	meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	multilib_foreach_abi gnome2_giomodule_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	multilib_foreach_abi gnome2_giomodule_cache_update
}
