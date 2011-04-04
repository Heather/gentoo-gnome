# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gtranslator/gtranslator-1.9.13.ebuild,v 1.7 2011/03/22 18:47:54 ranger Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="gnome? 2"

inherit eutils gnome2 python

DESCRIPTION="An enhanced gettext po file editor for GNOME"
HOMEPAGE="http://gtranslator.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc gnome +introspection"

RDEPEND="
	>=dev-libs/glib-2.25.10:2
	>=x11-libs/gtk+-2.91.3:3
	>=x11-libs/gtksourceview-2.90.0:3.0
	>=dev-libs/gdl-2.91.91:3
	>=dev-libs/libxml2-2.4.12:2
	>=dev-libs/json-glib-0.12.0
	>=dev-libs/libpeas-0.7.3[gtk]
	>=gnome-extra/libgda-4.2.0:4
	>=app-text/iso-codes-0.35

	gnome-base/gsettings-desktop-schemas

	gnome? ( gnome-extra/gnome-utils )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3 )"
DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.1.4
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	dev-util/pkgconfig
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING INSTALL NEWS README THANKS"
	# gtkspell hasn't been ported to gtk+3 yet
	G2CONF="${G2CONF}
		--disable-static
		--without-gtkspell
		$(use_with gnome dictionary)
		$(use_enable introspection)"
}
