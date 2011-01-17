# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-2.30.2.ebuild,v 1.1 2010/06/13 21:09:33 pacho Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="http://www.gnome.org/projects/epiphany/"

LICENSE="GPL-2"
SLOT="0"
IUSE="avahi doc +introspection networkmanager +nss test"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"
fi

# XXX: Should we add seed support? Seed seems to be unmaintained now.
RDEPEND=">=dev-libs/glib-2.25.3
	>=x11-libs/gtk+-2.99.0:3[introspection?]
	>=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.7
	>=x11-libs/startup-notification-0.5
	>=dev-libs/dbus-glib-0.71
	>=app-text/iso-codes-0.35
	>=net-libs/webkit-gtk-1.3.9:3[introspection?]
	>=net-libs/libsoup-gnome-2.29.91
	>=gnome-base/gnome-keyring-2.26.0
	>=gnome-base/gsettings-desktop-schemas-0.0.1

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11

	avahi? ( >=net-dns/avahi-0.6.22 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	networkmanager? ( net-misc/networkmanager )
	nss? ( dev-libs/nss )
	x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	gnome-base/gnome-common
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-shared
		--disable-maintainer-mode
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static
		--with-distributor-name=Gentoo
		--with-ca-file=${ROOT}/etc/ssl/certs/ca-certificates.crt
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
