# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-system-monitor/gnome-system-monitor-2.28.2.ebuild,v 1.6 2011/01/30 18:56:15 armin76 Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/libwnck-2.91.0:3
	>=gnome-base/libgtop-2.28.2:2
	>=x11-libs/gtk+-3.0:3
	>=x11-themes/gnome-icon-theme-2.31
	>=dev-cpp/gtkmm-2.99:3.0
	>=dev-cpp/glibmm-2.27:2
	>=dev-libs/libxml2-2.0:2
	>=gnome-base/librsvg-2.12:2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.41.0
	>=sys-devel/gettext-0.17
	>=app-text/gnome-doc-utils-0.20"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-scrollkeeper"
}

src_prepare() {
	# Add some useful patches from upstream git master
	# Use the correct maximum nice value on Linux
	epatch "${FILESDIR}/${PN}-3.0.1-linux-nice.patch"
	# Don't overflow the network history totals counters on 32-bit machines
	epatch "${FILESDIR}/${PN}"-3.0.1-32-bit-network-totals-overflow-{1,2,3}.patch

	gnome2_src_prepare
}
