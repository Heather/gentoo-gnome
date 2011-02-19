# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-2.30.3.ebuild,v 1.4 2011/01/19 21:26:57 hwoarang Exp $

EAPI="2"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
IUSE="avahi +introspection +ssh +telepathy test" #applet
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

RDEPEND=">=dev-libs/glib-2.25.11:2
	dev-libs/dbus-glib
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-base/gconf-2.16:2
	>=dev-libs/libpeas-0.7.2[gtk]
	>=dev-libs/libxml2-2.6.31:2
	>=net-libs/gtk-vnc-0.4.3:0

	gnome-base/gnome-keyring

	avahi? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3 )
	ssh? ( >=x11-libs/vte-0.20:2.90 )
	telepathy? ( >=net-libs/telepathy-glib-0.11.6 )"
	#applet? ( || ( gnome-base/gnome-panel[bonobo] <gnome-base/gnome-panel-2.32 ) )
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

src_prepare() {
	# Applet doesn't work with GNOME 3: gnome bug 642707
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-applet
		--enable-rdp
		$(use_enable avahi)
		$(use_enable introspection)
		$(use_enable ssh)
		$(use_enable telepathy)"

	gnome2_src_prepare
}

src_compile() {
	# GConf sucks. Thankfully it's going away: gnome bug 625895
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	# Dbus is needed for introspection because it runs vinagre, which needs GConf.
	# Hence, we need X. But that's okay, because dbus auto-exits after a while.
	Xemake || die
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${D}"/usr/share/doc/vinagre
}
