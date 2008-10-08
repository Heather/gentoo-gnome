# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/bug-buddy/bug-buddy-2.22.0.ebuild,v 1.5 2008/08/12 13:56:15 armin76 Exp $

inherit gnome2

DESCRIPTION="A graphical bug reporting tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="Ximian-logos GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="eds"

# Articifially raise gtk+ dep to support loading through XSettings
# also need g-settings-daemon, PDEPEND ?
RDEPEND=">=gnome-base/libbonobo-2
	>=dev-libs/glib-2.16.0
	>=gnome-base/libgnome-2
	>=gnome-base/gnome-menus-2.11.1
	>=gnome-base/libgnomeui-2.5.92
	>=dev-libs/libxml2-2.4.6
	>=x11-libs/gtk+-2.14
	>=net-libs/libsoup-2.4
	>=gnome-base/libgtop-2.13.3
	eds? ( >=gnome-extra/evolution-data-server-1.3 )
	>=gnome-base/gconf-2
	|| ( dev-libs/elfutils dev-libs/libelf )
	>=sys-devel/gdb-5.1"

DEPEND=${RDEPEND}"
	>=app-text/scrollkeeper-0.3.9
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable eds) --disable-scrollkeeper"
}
