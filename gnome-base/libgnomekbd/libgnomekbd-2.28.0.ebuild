# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomekbd/libgnomekbd-2.26.0.ebuild,v 1.3 2009/07/20 22:25:21 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit eutils gnome2 multilib

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-0.92
	>=dev-libs/dbus-glib-0.34
	>=gnome-base/gconf-2.14
	>=x11-libs/gtk+-2.13
	>=x11-libs/libxklavier-4.0"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	# Only user interaction required graphical tests at the time of 2.22.0 - not useful for us
	G2CONF="${G2CONF} --disable-tests --disable-static"
}

src_prepare() {
	gnome2_src_prepare

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed expression failed"
}

src_compile() {
	# FreeBSD doesn't like -j, upstream? bug #????
	use x86-fbsd && MAKEOPTS="${MAKEOPTS} -j1"
	gnome2_src_compile
}

pkg_preinst() {
	gnome2_pkg_preinst
	preserve_old_lib /usr/$(get_libdir)/libgnomekbd.so.3
	preserve_old_lib /usr/$(get_libdir)/libgnomekbdui.so.3
}

pkg_postinst() {
	gnome2_pkg_postinst
	preserve_old_lib_notify /usr/$(get_libdir)/libgnomekbd.so.3
	preserve_old_lib_notify /usr/$(get_libdir)/libgnomekbdui.so.3
}
