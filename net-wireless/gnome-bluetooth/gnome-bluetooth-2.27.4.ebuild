# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-gnome/bluez-gnome-1.8.ebuild,v 1.3 2009/02/27 23:48:54 dev-zero Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"
LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
IUSE="doc"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"

# FIXME: KEYWORDS for libunique
COMMON_DEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.15
	>=x11-libs/libnotify-0.4.3
	>=gnome-base/gconf-2.6
	>=dev-libs/dbus-glib-0.73
	>=sys-apps/hal-0.5.8
	dev-libs/libunique"
DEPEND="${COMMON_DEPEND}
	!!net-wireless/bluez-gnome
	dev-util/pkgconfig
	x11-proto/xproto
	doc? ( app-text/gnome-doc-utils )"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	>=app-mobilephone/obex-data-server-0.4"

DOCS="AUTHORS README NEWS ChangeLog"
G2CONF="${G2CONF} --disable-desktop-update --disable-icon-update"
