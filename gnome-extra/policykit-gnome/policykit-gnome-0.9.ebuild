# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 autotools

MY_PN="PolicyKit-gnome"

DESCRIPTION="PolicyKit policies and configurations for the GNOME desktop"
HOMEPAGE="http://hal.freedesktop.org/docs/PolicyKit"
SRC_URI="http://hal.freedesktop.org/releases/${MY_PN}-${PV}.tar.bz2"

LICENSE="|| ( LGPL-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=">=dev-libs/dbus-glib-0.71
		 >=x11-libs/gtk+-2.12
		 >=x11-libs/libsexy-0.1.11
		 >=gnome-base/gconf-2
		 >=gnome-base/gnome-vfs-2.4
		 >=gnome-base/libgnome-2.14
		 >=gnome-base/libgnomeui-2.14
		 >=sys-auth/policykit-0.7"
DEPEND="${RDEPEND}
		  sys-devel/gettext
		>=dev-util/pkgconfig-0.19
		>=dev-util/intltool-0.35.0
		>=app-text/scrollkeeper-0.3.14
		doc? ( >=dev-util/gtk-doc-1.3 )"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable examples)"
}
