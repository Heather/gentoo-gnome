# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/glade/glade-3.6.7.ebuild,v 1.10 2010/07/20 15:29:48 jer Exp $

EAPI="2"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="GNOME GUI Builder"
HOMEPAGE="http://glade.gnome.org/"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc +introspection python"

RDEPEND=">=x11-libs/gtk+-3.0.2:3
	>=dev-libs/libxml2-2.4.0:2
	introspection? ( >=dev-libs/gobject-introspection-0.10.1 )
	python? ( >=dev-python/pygobject-2.27.0 )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.41.0
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.17
	>=app-text/gnome-doc-utils-0.18
	app-text/docbook-xml-dtd:4.1.2
	doc? ( >=dev-util/gtk-doc-1.13 )
"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--enable-libtool-lock
		--disable-scrollkeeper
		$(use_enable introspection)
		$(use_enable python)"
}
