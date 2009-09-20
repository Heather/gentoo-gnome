# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-2.26.2.ebuild,v 1.3 2009/07/05 08:42:20 mrpouet Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
# Add location support once geoclue stops being idiotic with automagic deps
IUSE="applet doc map networkmanager python spell test webkit"

# FIXME: libnotify & libcanberra hard deps
RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.16.0
	>=gnome-base/gconf-2
	>=dev-libs/dbus-glib-0.51
	>=gnome-extra/evolution-data-server-1.2
	>=net-libs/telepathy-glib-0.7.34
	>=media-libs/libcanberra-0.4[gtk]
	>=x11-libs/libnotify-0.4.4
	>=gnome-base/gnome-keyring-2.22

	dev-libs/libunique
	net-libs/farsight2
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	net-libs/telepathy-farsight
	dev-libs/libxml2
	x11-libs/libX11

	applet? ( >=gnome-base/gnome-panel-2.10 )
	map? (
		>=media-libs/libchamplain-0.3.6[gtk]
		>=media-libs/clutter-gtk-0.10:1.0 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	python? (
		>=dev-lang/python-2.4.4-r5
		>=dev-python/pygtk-2 )
	spell? (
		app-text/enchant
		app-text/iso-codes )
	webkit? ( >=net-libs/webkit-gtk-1.1.7 )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	dev-libs/libxslt
	virtual/python
	doc? ( >=dev-util/gtk-doc-1.3 )
"

DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"

# FIXME: Tests are broken, upstream bug #576785
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-location
		$(use_enable applet megaphone)
		$(use_enable applet nothere)
		$(use_enable debug)
		$(use_with networkmanager connectivity nm)
		$(use_enable map)
		$(use_enable python)
		$(use_enable spell)
		$(use_enable test coding-style-checks)
		$(use_enable webkit)
	"
}

src_prepare() {
	gnome2_src_prepare

	# Remove hard enabled -Werror (see AM_MAINTAINER_MODE), bug 218687
	sed -i "s:-Werror::g" configure || die "sed 1 failed"

	# FIXME: report upstream their package is broken
	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed 2 failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed."
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "You will need to install connection managers yourself."
	elog "MSN: net-voip/telepathy-butterfly"
	elog "Jabber and Gtalk: net-voip/telepathy-gabble"
	elog "IRC: net-irc/telepathy-idle"
	elog "Link-local XMPP: net-irc/telepathy-salut"
	echo
}
