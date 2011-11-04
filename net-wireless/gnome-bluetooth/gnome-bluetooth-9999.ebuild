# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gnome-bluetooth/gnome-bluetooth-2.32.0.ebuild,v 1.4 2010/12/19 11:51:36 pacho Exp $

EAPI="4"
GCONF_DEBUG="yes"
# libgnome-bluetooth-applet.la is needed by gnome-shell during compilation
GNOME2_LA_PUNT="no"

inherit gnome2 multilib
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
IUSE="doc +introspection sendto"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~x86"
fi

COMMON_DEPEND=">=dev-libs/glib-2.25.7:2
	>=x11-libs/gtk+-2.91.3:3[introspection?]
	>=x11-libs/libnotify-0.7.0
	>=dev-libs/dbus-glib-0.74

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	sendto? ( >=gnome-extra/nautilus-sendto-2.91 )
"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd
	sys-fs/udev"
# To break circular dependencies
PDEPEND=">=gnome-base/gnome-control-center-2.91"
DEPEND="${COMMON_DEPEND}
	!!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
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
	# FIXME: Add geoclue support
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_enable sendto nautilus-sendto)
		--disable-moblin
		--disable-desktop-update
		--disable-icon-update
		--disable-schemas-compile
		--disable-static"
	DOCS="AUTHORS README NEWS ChangeLog"

	enewgroup plugdev
}

src_prepare() {
	# Add missing files for intltool checks
	echo "sendto/bluetooth-sendto.desktop.in" >> po/POTFILES.in
	echo "wizard/bluetooth-wizard.desktop.in" >> po/POTFILES.in

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	local la
	for la in gnome-bluetooth/plugins/libgbtgeoclue.la \
			 control-center-1/panels/libbluetooth.la \
			 libgnome-bluetooth.la; do
		rm -v "${ED}/usr/$(get_libdir)/${la}" || die
	done

	insinto /$(get_libdir)/udev/rules.d
	doins "${FILESDIR}"/80-rfkill.rules || die "udev rules installation failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "Don't forget to add yourself to the plugdev group "
	elog "if you want to be able to control bluetooth transmitter."
}
