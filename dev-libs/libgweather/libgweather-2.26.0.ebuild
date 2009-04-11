# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgweather/libgweather-2.24.3.ebuild,v 1.2 2009/01/24 11:18:52 armin76 Exp $

EAPI="2"

inherit gnome2

DESCRIPTION="Library to access weather information from online services"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="python"

RDEPEND=">=x11-libs/gtk+-2.11
	>=dev-libs/glib-2.13
	>=gnome-base/gconf-2.8
	>=net-libs/libsoup-2.25.1:2.4[gnome]
	>=dev-libs/libxml2-2.6.0
	python? (
		>=dev-python/pygobject-2
		>=dev-python/pygtk-2 )
	!<gnome-base/gnome-applets-2.22.0"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.3
	>=dev-util/pkgconfig-0.19
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS"

pkg_setup() {
	# FIXME: decide what to do with --enable-locations-compression
	G2CONF="${G2CONF}
		--disable-all-translations-in-one-xml
		--disable-static
		$(use_enable python)"
}
