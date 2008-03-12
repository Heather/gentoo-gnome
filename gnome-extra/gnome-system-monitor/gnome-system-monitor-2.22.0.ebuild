# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-system-monitor/gnome-system-monitor-2.20.2.ebuild,v 1.7 2008/02/04 04:29:57 jer Exp $

inherit gnome2 eutils

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.9.1
	>=gnome-base/gconf-2
	>=x11-libs/libwnck-2.5
	>=gnome-base/libgtop-2.19.3
	>=x11-libs/gtk+-2.12
	>=gnome-base/gnome-vfs-2.6
	>=x11-themes/gnome-icon-theme-2.15.3
	>=dev-cpp/gtkmm-2.8
	>=dev-cpp/glibmm-2.14
	>=gnome-base/librsvg-2.21
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper"
}
