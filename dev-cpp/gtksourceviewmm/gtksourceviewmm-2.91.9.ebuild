# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtksourceviewmm/gtksourceviewmm-2.10.1.ebuild,v 1.6 2011/01/24 16:22:47 eva Exp $

EAPI="2"

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
	>=dev-cpp/mm-common-0.9.4
	doc? ( app-doc/doxygen )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	G2CONF="${G2CONF} $(use_enable doc documentation)"
}

src_prepare() {
	gnome2_src_prepare

	# Remove docs from SUBDIRS so that docs are not installed, as
	# we handle it in src_install.
	sed -i -e 's|^\(SUBDIRS =.*\)$(doc_subdirs)\(.*\)|\1\2|' Makefile.in || \
		die "sed Makefile.in failed"
}

src_install() {
	gnome2_src_install
	use doc && dohtml -r docs/reference/html/*
}
