# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Disk Utility for GNOME using devicekit-disks"
HOMEPAGE="http://git.gnome.org/cgit/gnome-disk-utility/"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +nautilus"

COMMON_DEPEND="
	>=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/libunique-1.0
	>=x11-libs/libsexy-0.1.11
	>=x11-libs/gtk+-2.6
	>=sys-auth/policykit-0.7
	>=gnome-extra/policykit-gnome-0.7
	>=gnome-base/gnome-keyring-2.22

	nautilus? ( >=gnome-base/nautilus-2.24 )"
RDEPEND="${COMMON_DEPEND}
	sys-apps/devicekit-disks"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.3 )"
DOCS="AUTHORS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable nautilus)"
}
