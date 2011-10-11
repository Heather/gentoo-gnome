# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-user-share/gnome-user-share-2.30.1.ebuild,v 1.1 2010/09/28 19:05:16 eva Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib

DESCRIPTION="Personal file sharing for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# FIXME: could libnotify be made optional ?
# FIXME: gnome-bluetooth is a hard-dep
# bluetooth is pure runtime dep (dbus)
RDEPEND=">=dev-libs/glib-2.16.0:2
	>=x11-libs/gtk+-3.0.0:3
	>=app-mobilephone/obex-data-server-0.4
	>=dev-libs/dbus-glib-0.70
	dev-libs/libunique:3
	>=gnome-base/gconf-2.10:2
	>=gnome-base/nautilus-2.91.7
	media-libs/libcanberra[gtk3]
	>=net-wireless/gnome-bluetooth-2.91.5:2
	>=net-wireless/bluez-4.18
	>=sys-apps/dbus-1.1.1
	>=www-apache/mod_dnssd-0.6
	>=www-servers/apache-2.2[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
	>=x11-libs/libnotify-0.7"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.17
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--with-httpd=apache2
		--with-modules-path=/usr/$(get_libdir)/apache2/modules/"
}

src_prepare() {
	gnome2_src_prepare

	# Ubuntu patch to work around kernel 3.x's inability to bind to AF_UNSPEC
	# sockets. See https://bugzilla.gnome.org/show_bug.cgi?id=660658 and
	# https://bugs.launchpad.net/ubuntu/+source/gnome-user-share/+bug/856732
	epatch "${FILESDIR}/${PN}-3.0.0-AF_INET.patch"
}
