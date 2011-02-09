# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/glade/glade-3.6.7.ebuild,v 1.10 2010/07/20 15:29:48 jer Exp $

EAPI="2"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="GNOME GUI Builder"
HOMEPAGE="http://glade.gnome.org/"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc python"

RDEPEND=">=dev-libs/glib-2.8.0:2
	>=x11-libs/gtk+-2.99.0:3
	>=dev-libs/libxml2-2.4.0:2
	python? ( >=dev-python/pygtk-2.10.0 )
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

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--enable-libtool-lock
		--disable-scrollkeeper
		$(use_enable python)"
}
