# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="The Gnome Devtool Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2.1"
SLOT="3"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="doc +introspection"

RDEPEND="dev-libs/glib:2
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=dev-libs/libxml2-2.4:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.4
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.4 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)"
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}
