# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-icon-theme/gnome-icon-theme-2.30.3.ebuild,v 1.2 2010/07/20 02:30:50 jer Exp $

GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GNOME 2 symbolic icon themes"
HOMEPAGE="http://www.gnome.org/"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/pkgconfig-0.19"
DOCS="AUTHORS NEWS TODO"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# FIXME: double check potential LINGUAS problem
pkg_setup() {
	G2CONF="${G2CONF} --enable-icon-mapping"
}
