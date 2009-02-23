# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-sendto/nautilus-sendto-0.14.0.ebuild,v 1.1 2008/03/29 20:46:08 compnerd Exp $

inherit gnome2 eutils autotools

DESCRIPTION="A nautilus extension for sending files to locations"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="balsa bluetooth claws eds empathy gajim pidgin sylpheed thunderbird upnp"

RDEPEND=">=x11-libs/gtk+-2.4
	>=dev-libs/glib-2.6
	>=gnome-base/libglade-2.5.1
	>=gnome-base/nautilus-2.14
	>=gnome-base/gconf-2.13.0
	balsa? ( mail-client/balsa )
	bluetooth? ( >=dev-libs/dbus-glib-0.60 )
	eds? ( >=gnome-extra/evolution-data-server-1.5.3 )
	gajim? ( net-im/gajim
			 >=dev-libs/dbus-glib-0.60 )
	pidgin? ( >=net-im/pidgin-2.0.0 )
	sylpheed?  ( mail-client/sylpheed )
	claws? ( mail-client/claws-mail	)
	thunderbird? ( 
		|| ( mail-client/mozilla-thunderbird 
			 mail-client/mozilla-thunderbird-bin ) )
	upnp? ( >=net-libs/gupnp-av-0.2.1 )
"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=gnome-base/gnome-common-0.12
		>=dev-util/pkgconfig-0.19
		>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"

_use_plugin() {
	if use ${1}; then 
		G2CONF="${G2CONF}${2:-"${1}"},"
	fi
}

pkg_setup() {
	G2CONF="${G2CONF} --with-plugins="
	_use_plugin bluetooth
	_use_plugin eds evolution
	_use_plugin pidgin
	_use_plugin gajim
	_use_plugin claws sylpheed-claws
	_use_plugin sylpheed sylpheed-claws
	_use_plugin thunderbird
	_use_plugin upnp
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix plugin versioning for pidgin plugin
	epatch "${FILESDIR}"/${P}-pidgin-plugin-versioning.patch
	eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use pidgin; then
		elog "To enable SendTo support in pidgin, you must enable the plugin in pidgin"
		elog "Check Tools -> Preferences -> Plugins in the pidgin menu."
	fi
}
