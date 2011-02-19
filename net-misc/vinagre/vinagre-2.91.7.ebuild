# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-2.30.3.ebuild,v 1.6 2011/01/30 19:10:27 armin76 Exp $

EAPI="2"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="applet avahi +ssh +telepathy test"

RDEPEND=">=dev-libs/glib-2.25.11
	dev-libs/dbus-glib
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-base/gconf-2.16
	>=dev-libs/libpeas-0.7.2[gtk]
	>=dev-libs/libxml2-2.6.31
	>=net-libs/gtk-vnc-0.4.3:3

	gnome-base/gnome-keyring

	applet? ( || ( gnome-base/gnome-panel[bonobo] <gnome-base/gnome-panel-2.32 ) )
	avahi? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
	ssh? ( >=x11-libs/vte-0.20 )
	telepathy? ( >=net-libs/telepathy-glib-0.11.6 )"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		$(use_enable avahi)
		$(use_enable applet)
		$(use_enable ssh)
		$(use_enable telepathy)"
}

src_compile() {
	# XXX: This sucks :S
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	gnome2_src_compile
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${D}"/usr/share/doc/vinagre
}
