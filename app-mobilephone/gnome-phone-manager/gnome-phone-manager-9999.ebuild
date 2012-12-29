# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A program created to allow you to control aspects of your mobile phone from your GNOME 2 desktop"
HOMEPAGE="http://live.gnome.org/PhoneManager"

LICENSE="GPL-2"
SLOT="0"
# XXX: telepathy support is considered experimental
IUSE="telepathy"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=app-mobilephone/gnokii-0.6.28[bluetooth]
	>=dev-libs/glib-2.25:2
	>=gnome-base/gconf-2:2
	>=gnome-base/orbit-2
	>=gnome-extra/evolution-data-server-3.6
	>=net-wireless/gnome-bluetooth-3:2
	>=x11-libs/gtk+-3:3
	>=x11-themes/gnome-icon-theme-2.19.1
	dev-libs/dbus-glib
	dev-libs/openobex
	media-libs/libcanberra[gtk3]
	net-wireless/bluez
	telepathy? ( net-libs/telepathy-glib )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	gnome-base/gnome-common
	virtual/pkgconfig
"
# gnome-common needed for eautoreconf

src_prepare() {
	# Fix build with eds-3.6
	epatch "${FILESDIR}"/0001-Adapt-to-Evolution-Data-Server-API-changes.patch

	[[ ${PV} != 9999 ]] && eautoreconf
	gnome2_src_prepare
}

src_configure() {
	G2CONF="${G2CONF}
		$(use_enable telepathy)
		--enable-bluetooth-plugin
		--disable-static"
	gnome2_src_configure
}
