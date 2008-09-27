# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgweather/libgweather-2.22.1.1.ebuild,v 1.1 2008/04/09 22:13:26 eva Exp $
EAPI=1

inherit gnome2

DESCRIPTION="Library to access weather information from online services"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.11
		 >=dev-libs/glib-2.13
		 >=gnome-base/gconf-2.8
		 net-libs/libsoup:2.4
		 >=dev-libs/libxml2-2.6.0
		 !<gnome-base/gnome-applets-2.22.0"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.40
		>=dev-util/pkgconfig-0.19"

pkg_setup() {
	G2CONF="${G2CONF} --disable-all-translations-in-one-xml"
}

pkg_postinst() {
	gnome2_pkg_postinst

	ewarn "Please run revdep-rebuild after upgrading this package."
}
