# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-2.30.3.ebuild,v 1.4 2011/01/19 21:26:57 hwoarang Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
IUSE="applet avahi +introspection +telepathy test" #+ssh
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

RDEPEND=">=dev-libs/glib-2.25.11:2
	>=x11-libs/gtk+-3.0.3:3
	>=dev-libs/libpeas-0.7.2[gtk]
	>=dev-libs/libxml2-2.6.31:2
	>=net-libs/gtk-vnc-0.4.3-r300

	gnome-base/gnome-keyring

	avahi? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3 )
	telepathy? (
		dev-libs/dbus-glib
		>=net-libs/telepathy-glib-0.11.6 )
	applet? ( >=gnome-base/gnome-panel-2.91 )"
#	ssh? ( >=x11-libs/vte-0.20:2.90 )
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog ChangeLog.pre-git NEWS README"

src_prepare() {
	# Spice support?
	# SSH support fails to compile
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-spice
		--disable-ssh
		--enable-rdp
		$(use_with panelapplet)
		$(use_with avahi)
		$(use_enable introspection)
		$(use_with telepathy)"
		#$(use_enable ssh)

	gnome2_src_prepare
}

src_compile() {
	# Dbus is needed for introspection because it runs vinagre.
	# Hence, we need X. But that's okay, because dbus auto-exits after a while.
	# Also, we need the schemas from data/ to run the app for introspection.
	local updater="${EROOT}${GLIB_COMPILE_SCHEMAS}"
	${updater} --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR=${S}/data Xemake || die
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${ED}"/usr/share/doc/vinagre
}
