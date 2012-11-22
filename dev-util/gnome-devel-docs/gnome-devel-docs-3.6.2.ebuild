# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Documentation for developing for the GNOME desktop environment"
HOMEPAGE="http://developer.gnome.org/"

LICENSE="FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
