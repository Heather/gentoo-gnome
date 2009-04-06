# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-user-share/gnome-user-share-0.41.ebuild,v 1.2 2009/01/06 06:02:46 mr_bones_ Exp $

inherit eutils gnome2

DESCRIPTION="Personal file sharing for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

# FIXME: could libnotify be made optional ?
#        is consolekit needed or not ?
# bluetooth is pure runtime dep (dbus)
RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.14
	>=gnome-base/gconf-2.10
	>=sys-apps/dbus-1.1.1
	>=dev-libs/dbus-glib-0.70
	www-apache/mod_dnssd
	>=www-servers/apache-2.2
	x11-libs/libnotify
	bluetooth? (
		>=net-wireless/bluez-4.18
		>=app-mobilephone/obex-data-server-0.4 )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.17
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	if ! built_with_use www-servers/apache apache2_modules_dav \
	apache2_modules_dav_fs apache2_modules_authn_file \
	apache2_modules_auth_digest apache2_modules_authz_groupfile ; then
		eerror "You need to build www-servers/apache with APACHE2_MODULES='dav dav_fs authn_file auth_digest authz_groupfile'"
		die "re-emerge www-servers/apache with APACHE2_MODULES='dav dav_fs authn_file auth_digest authz_groupfile'"
	fi

	G2CONF="${G2CONF}
		--with-httpd=apache2
		--with-modules-path=/usr/lib/apache2/modules/"
}
