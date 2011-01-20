# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gnome-bluetooth/gnome-bluetooth-2.32.0.ebuild,v 1.4 2010/12/19 11:51:36 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit eutils gnome2 multilib

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
IUSE="doc +introspection nautilus"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~x86"
fi

COMMON_DEPEND=">=dev-libs/glib-2.25.7:2
	>=x11-libs/gtk+-2.91.3:3[introspection?]
	>=x11-libs/libnotify-0.7.0
	>=dev-libs/dbus-glib-0.74
	>=gnome-base/gnome-control-center-2.91

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	nautilus? (
		>=gnome-extra/nautilus-sendto-2.31.7
		<gnome-extra/nautilus-sendto-2.91.0 )"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd
	sys-fs/udev"
DEPEND="${COMMON_DEPEND}
	!!net-wireless/bluez-gnome
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	dev-libs/libxml2
	>=dev-util/intltool-0.40.0
	dev-util/pkgconfig
	>=sys-devel/gettext-0.17
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/xproto
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_enable nautilus nautilus-sendto)
		--disable-maintainer-mode
		--disable-moblin
		--disable-desktop-update
		--disable-icon-update
		--disable-schemas-compile"
	DOCS="AUTHORS README NEWS ChangeLog"

	enewgroup plugdev
}

src_install() {
	gnome2_src_install
	find "${ED}"/usr/$(get_libdir)/${PN}/plugins -name "*.la" -delete \
		|| die "la file removal failed (1)"
	if use nautilus; then
		find "${ED}"/usr/$(get_libdir)/nautilus-sendto/plugins -name "*.la" -delete \
			|| die "la file removal failed (1)"
	fi

	insinto /$(get_libdir)/udev/rules.d
	doins "${FILESDIR}"/80-rfkill.rules || die "udev rules installation failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "Don't forget to add yourself to the plugdev group "
	elog "if you want to be able to control bluetooth transmitter."
}
