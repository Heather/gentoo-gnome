# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/seahorse-plugins/seahorse-plugins-2.30.1-r1.ebuild,v 1.7 2010/10/17 15:26:51 armin76 Exp $

EAPI="2"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"
SRC_URI="mirror://gentoo/${P}_f2b21615.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="applet debug gedit libnotify nautilus test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

# Note: always support only the latest gedit
RDEPEND="
	>=dev-libs/glib-2.16
	>=gnome-base/gconf-2.0
	>=x11-libs/gtk+-2.90.0:3
	>=dev-libs/dbus-glib-0.72
	>=app-crypt/gpgme-1.0.0
	>=app-crypt/seahorse-2.91
	|| (
		<app-crypt/seahorse-3.1.4
		>=x11-libs/libcryptui-2.91 )
	>=gnome-base/gnome-keyring-2.25

	|| (
		=app-crypt/gnupg-1.4*
		=app-crypt/gnupg-2.0* )

	nautilus? ( >=gnome-base/nautilus-2.12 )
	gedit? ( >=app-editors/gedit-2.20 )
	applet? ( >=gnome-base/gnome-panel-2.91.6 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35
"
src_prepare() {
	G2CONF="${G2CONF}
		--enable-agent
		--disable-update-mime-database
		--disable-static
		--disable-epiphany
		--with-gtk=3.0
		$(use_enable applet)
		$(use_enable debug)
		$(use_enable gedit)
		$(use_enable libnotify)
		$(use_enable nautilus)
		$(use_enable test tests)"

	# NOTE: All these are merged upstream, remove for release
	# https://bugzilla.gnome.org/show_bug.cgi?id=632800
	epatch "${FILESDIR}/${PN}-fix-build-with-libnotify-0.7.patch"
	# https://bugzilla.gnome.org/show_bug.cgi?id=639493
	epatch "${FILESDIR}/${PN}-port-to-latest-gtk-3.patch"
	# Port to latest changes in gnome-keyring
	epatch "${FILESDIR}/${PN}-remove-agent.patch"
	# Port to latest gnome-panel
	epatch "${FILESDIR}/${PN}-fix-panel-applet.patch"

	# All this is needed because it's a git snapshot, remove for next release
	gnome-doc-common
	gnome-doc-prepare --automake
	intltoolize --force
	AT_M4DIR=m4 eautoreconf

	gnome2_src_prepare
}
