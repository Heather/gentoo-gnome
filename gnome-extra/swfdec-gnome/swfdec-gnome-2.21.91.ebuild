# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/swfdec-gnome/swfdec-gnome-0.5.5.ebuild,v 1.1 2007/12/22 10:27:18 pclouds Exp $

inherit gnome2

DESCRIPTION="flash player and thumbnailer for GNOME"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12.0
		gnome-base/gconf
		>=media-libs/swfdec-0.6"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext"

pkg_setup() {
	if !built_with_use media-libs/swfdec soup ; then
		einfo "You must build swfdec with the soup USE flag to build"
		einfo "swfdec-gtk, which is required by swfdec-gnome"
		die "Please re-emerge media-libs/swfdec with the soup USE flag"
	fi
}
