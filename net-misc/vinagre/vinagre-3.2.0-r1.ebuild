# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-2.30.3.ebuild,v 1.4 2011/01/19 21:26:57 hwoarang Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="avahi +ssh +telepathy test"

# cairo used in vinagre-tab
# gdk-pixbuf used all over the place
RDEPEND=">=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0.3:3
	>=gnome-base/gnome-keyring-1
	>=dev-libs/libxml2-2.6.31:2
	>=net-libs/gtk-vnc-0.4.3[gtk3]
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-themes/gnome-icon-theme

	avahi? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
	ssh? ( >=x11-libs/vte-0.20:2.90 )
	telepathy? (
		dev-libs/dbus-glib
		>=net-libs/telepathy-glib-0.11.6 )
"
DEPEND="${RDEPEND}
	dev-lang/vala:0.12
	gnome-base/gnome-common
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.16
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	>=sys-devel/gettext-0.17
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog ChangeLog.pre-git NEWS README"
	# Spice support?
	# SSH support fails to compile
	G2CONF="${G2CONF}
		VALAC=$(type -p valac-0.12)
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-spice
		--enable-rdp
		$(use_with avahi)
		$(use_enable ssh)
		$(use_with telepathy)"
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=660531
	epatch "${FILESDIR}/${PN}-3.2.0-implicit-function-declarations.patch"
	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${ED}"/usr/share/doc/vinagre
}
