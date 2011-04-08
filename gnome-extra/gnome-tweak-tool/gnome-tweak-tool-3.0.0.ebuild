# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-screensaver/gnome-screensaver-2.30.2.ebuild,v 1.2 2010/11/02 02:33:58 ford_prefect Exp $

EAPI="3"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Tool to customize GNOME 3 options"
HOMEPAGE="http://live.gnome.org/GnomeTweakTool"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

COMMON_DEPEND="
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=dev-python/pygobject-2.28.0:2
	gnome-base/gconf:2"
RDEPEND="${COMMON_DEPEND}
	x11-libs/gtk+:3[introspection]
	gnome-base/gconf:2[introspection]"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	>=dev-util/pkgconfig-0.9
	>=sys-devel/gettext-0.17"

DOCS="NEWS README"
G2CONF="--disable-schemas-compile"
