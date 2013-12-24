# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
GNOME_LIVE_MODULE="phonemgr"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A program created to allow you to control aspects of your mobile phone from your GNOME desktop"
HOMEPAGE="http://live.gnome.org/PhoneManager"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~x86"
fi
IUSE="gnome"
# telepathy support is considered experimental

RDEPEND="
	>=app-mobilephone/gnokii-0.6.28[bluetooth]
	dev-libs/dbus-glib
	>=dev-libs/glib-2.31:2
	dev-libs/openobex
	>=gnome-base/gconf-2:2
	>=gnome-extra/evolution-data-server-3.6
	media-libs/libcanberra[gtk3]
	net-wireless/bluez
	>=net-wireless/gnome-bluetooth-3.3:2
	>=x11-themes/gnome-icon-theme-2.19.1
	>=x11-libs/gtk+-3:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	gnome-base/gnome-common
	virtual/pkgconfig
"
# gnome-common needed for eautoreconf

src_prepare() {
	# Fix eds-3.6 building, upstream bug #680927
	epatch "${FILESDIR}"/0001-Adapt-to-Evolution-Data-Server-API-changes.patch

	[[ ${PV} != 9999 ]] && eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable gnome bluetooth-plugin) \
		--disable-telepathy \
		--disable-static
}
