# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-2.24.2.ebuild,v 1.1 2008/12/10 03:12:54 leio Exp $

EAPI="2"

inherit gnome2

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="avahi test"

# FIXME: make gnome-panel applet optional ?

RDEPEND=">=dev-libs/glib-2.17.0
	>=x11-libs/gtk+-2.13.1
	>=gnome-base/libglade-2.6
	>=gnome-base/gconf-2.16
	>=net-libs/gtk-vnc-0.3.8
	>=gnome-base/gnome-keyring-1
	>=gnome-base/gnome-panel-2
	avahi? ( >=net-dns/avahi-0.6.22[dbus,gtk] )"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		$(use_enable avahi)"
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${D}"/usr/share/doc/vinagre
}
