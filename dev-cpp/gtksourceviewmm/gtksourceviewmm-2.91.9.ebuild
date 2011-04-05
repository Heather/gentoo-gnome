# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtksourceviewmm/gtksourceviewmm-2.10.1.ebuild,v 1.6 2011/01/24 16:22:47 eva Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="C++ bindings for gtksourceview"
HOMEPAGE="http://projects.gnome.org/gtksourceviewmm/"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"
SLOT="3.0"
LICENSE="LGPL-2.1"

RDEPEND=">=dev-cpp/glibmm-2.27.93:2
	>=dev-cpp/gtkmm-2.91.2:3.0
	>=x11-libs/gtksourceview-2.91.9:3.0

	dev-cpp/atkmm
	dev-cpp/cairomm
	dev-cpp/pangomm:1.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	G2CONF="${G2CONF} $(use_enable doc documentation)"
}
