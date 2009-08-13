# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-icon-theme/gnome-icon-theme-2.26.0.ebuild,v 1.1 2009/05/03 22:20:53 eva Exp $

GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GNOME 2 default icon themes"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.40
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog NEWS TODO"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

pkg_setup() {
	G2CONF="${G2CONF} --enable-icon-mapping"
}
