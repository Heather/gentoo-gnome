# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomekbd/libgnomekbd-2.32.0.ebuild,v 1.2 2010/10/20 21:29:54 eva Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
IUSE="+introspection test"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

RDEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.91.7:3[introspection?]
	>=x11-libs/libxklavier-5.1
	
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		$(use_enable test tests)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

#src_compile() {
	# FreeBSD doesn't like -j, upstream? bug #176517
	# FIXME: Please re-test and notify us if still valid,
	# disabling for now
	# use x86-fbsd && MAKEOPTS="${MAKEOPTS} -j1"
#	gnome2_src_compile
#}
