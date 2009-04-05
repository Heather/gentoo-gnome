# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-2.24.1.ebuild,v 1.4 2009/01/07 17:17:43 armin76 Exp $

EAPI="1"

inherit gnome2

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"
IUSE="applet doc python spell test"

# FIXME: libnotify & libcanberra hard deps
RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.14.0
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	>=dev-libs/dbus-glib-0.51
	>=gnome-extra/evolution-data-server-1.2
	>=net-libs/telepathy-glib-0.7.23
	>=net-im/telepathy-mission-control-4.61
	>=media-libs/libcanberra-0.4
	>=x11-libs/libnotify-0.4.4

	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	net-libs/telepathy-farsight
	dev-libs/libxml2

	applet? ( >=gnome-base/gnome-panel-2.10 )
	spell? (
		app-text/enchant
		app-text/iso-codes )
	python? (
		>=dev-lang/python-2.4.4-r5
		>=dev-python/pygtk-2 )"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	test? ( >=dev-libs/check-0.9.4 )
	dev-libs/libxslt
	virtual/python
	doc? ( >=dev-util/gtk-doc-1.3 )"

DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"

# FIXME: Tests are broken, upstream bug #576785
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable debug)
		$(use_enable spell)
		$(use_enable python)
		$(use_enable applet megaphone)
		$(use_enable applet nothere)"
}

src_unpack() {
	gnome2_src_unpack

	# FIXME: This needs to be upstreamed before moving to tree
	cp "${FILESDIR}/empathy-new-account.png" "${S}/help/C/figures/" \
		|| die "Copying empathy-new-account.png failed"

	# Remove hard enabled -Werror (see AM_MAINTAINER_MODE), bug 218687
	sed -i "s:-Werror::g" configure || die "sed failed"
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
	echo
}
