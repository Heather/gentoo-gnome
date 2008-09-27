# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-cd-burner/nautilus-cd-burner-2.22.1.ebuild,v 1.5 2008/08/12 13:54:26 armin76 Exp $

inherit gnome2

DESCRIPTION="CD and DVD writer plugin for Nautilus"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cdr dvdr"

RDEPEND=">=dev-libs/glib-2.15.4
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=gnome-base/eel-2.14
	>=gnome-base/nautilus-2.22.2
	>=gnome-base/gconf-2
	>=gnome-base/gnome-mount-0.4
	>=sys-apps/hal-0.5.7
	>=dev-libs/dbus-glib-0.71
	cdr? (
		virtual/cdrtools
		app-cdr/cdrdao
	)
	dvdr? ( >=app-cdr/dvd+rw-tools-6.1 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --enable-gnome-mount"
}
