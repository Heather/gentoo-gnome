# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-2.30.2.ebuild,v 1.1 2010/06/13 21:09:33 pacho Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="http://www.gnome.org/projects/epiphany/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"

IUSE="avahi doc +introspection networkmanager +nss test"

# TODO: add seed support
RDEPEND=">=dev-libs/glib-2.19.7
	>=x11-libs/gtk+-2.90.4:3[introspection?]
	>=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.7
	>=x11-libs/startup-notification-0.5
	>=x11-libs/libnotify-0.5.1
	>=dev-libs/dbus-glib-0.71
	>=gnome-base/gconf-2
	>=app-text/iso-codes-0.35
	>=net-libs/webkit-gtk-1.3.2:3.0[introspection?]
	>=net-libs/libsoup-2.29.91[gnome]
	>=gnome-base/gnome-keyring-2.26.0

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11

	avahi? ( >=net-dns/avahi-0.6.22 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	networkmanager? ( net-misc/networkmanager )
	nss? ( dev-libs/nss )
	x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	>=app-text/gnome-doc-utils-0.3.2
	sys-devel/gettext
	gnome-base/gnome-common
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-maintainer-mode
		--with-distributor-name=Gentoo
		$(use_enable avahi zeroconf)
		$(use_enable introspection)
		$(use_enable networkmanager network-manager)
		$(use_enable nss)
		$(use_enable test tests)"
}

src_compile() {
	# Fix sandbox error with USE="introspection"
	# https://bugs.webkit.org/show_bug.cgi?id=35471
	addpredict "$(unset HOME; echo ~)/.local"
	emake || die "Compile failed"
}
