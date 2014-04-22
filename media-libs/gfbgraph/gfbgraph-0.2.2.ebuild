# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools gnome3

DESCRIPTION="GLib/GObject wrapper for the Facebook Graph API"
HOMEPAGE="http://www.gnome.org"
SRC_URI="https://download.gnome.org/sources/gfbgraph/0.2/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0.2"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-libs/gnome-online-accounts
	dev-libs/gobject-introspection
	dev-util/gtk-doc
	dev-libs/json-glib
	net-libs/rest"

RDEPEND="${DEPEND}"

DOCS=( "README" "COPYING" "AUTHORS" "ChangeLog" "INSTALL" "NEWS" )
AUTOTOOLS_AUTORECONF="yes"

src_prepare() {
	sed -i -e 's:libgfbgraphdoc_DATA:noinst_DATA:g' Makefile.am
	gnome3_src_prepare
}
