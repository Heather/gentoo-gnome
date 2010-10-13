# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/mousetweaks/mousetweaks-2.30.2.ebuild,v 1.6 2010/10/09 10:28:25 ssuominen Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Mouse accessibility enhancements for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/Mousetweaks/Home"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.25.9:2
	>=x11-libs/gtk+-2.18:2
	>=gnome-base/gconf-2.16
	>=gnome-base/gnome-panel-2

	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXfixes
	x11-libs/libXcursor"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.17"
# eautoreconf needs:
#	gnome-base/gnome-common

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

