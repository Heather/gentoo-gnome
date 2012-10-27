# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-sendto/nautilus-sendto-3.0.3.ebuild,v 1.1 2012/05/13 00:24:42 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib

DESCRIPTION="A nautilus extension for sending files to locations"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdr gajim +mail pidgin upnp"

COMMON_DEPEND=">=x11-libs/gtk+-2.90.3:3[X(+)]
	>=dev-libs/glib-2.25.9:2
	cdr? ( >=app-cdr/brasero-2.26.0[nautilus] )
	gajim? (
		net-im/gajim
		>=dev-libs/dbus-glib-0.60 )
	mail? ( >=gnome-extra/evolution-data-server-3.5.3 )
	pidgin? (
		>=net-im/pidgin-2.0.0
		>=dev-libs/dbus-glib-0.60 )
	upnp? ( >=net-libs/gupnp-0.13.0 )"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-2.91.1[sendto]"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=gnome-base/nautilus-2.91.1
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"
# Needed for eautoreconf
#	>=gnome-base/gnome-common-0.12

_use_plugin() {
	if use ${1}; then
		G2CONF="${G2CONF}${2:-"${1}"},"
	fi
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--with-plugins=removable-devices,"
	_use_plugin cdr nautilus-burn
	_use_plugin mail evolution
	_use_plugin pidgin
	_use_plugin gajim
	_use_plugin upnp
	gnome2_src_configure
}

src_install() {
	gnome2_src_install

	# Prevent file collision with nautilus-3 (which installs its own copy of
	# libnautilus-sendto.so)
	rm -r "${ED}/usr/$(get_libdir)/nautilus/extensions-"*
}
