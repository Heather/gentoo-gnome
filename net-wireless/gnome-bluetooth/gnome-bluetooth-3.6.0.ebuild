# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib toolchain-funcs user
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="2"
IUSE="doc +introspection sendto"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

COMMON_DEPEND=">=dev-libs/glib-2.29.90:2
	>=x11-libs/gtk+-2.91.3:3[introspection?]
	>=x11-libs/libnotify-0.7.0
	sys-fs/udev

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	sendto? ( >=gnome-extra/nautilus-sendto-2.91 )
"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${COMMON_DEPEND}
	!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxml2:2
	>=dev-util/intltool-0.40.0
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/xproto
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools"
fi

pkg_setup() {
	# FIXME: Add geoclue support
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_enable sendto nautilus-sendto)
		--enable-documentation
		--disable-maintainer-mode
		--disable-desktop-update
		--disable-icon-update
		--disable-schemas-compile
		--disable-static"
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"
	DOCS="AUTHORS README NEWS ChangeLog"

	enewgroup plugdev
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=685002
	epatch "${FILESDIR}/${PN}-3.6.0-desktop-files.patch"

	# Regenerate gdbus-codegen files to allow using any glib version; bug #436236
	if [[ ${PV} != 9999 ]]; then
		rm -v lib/bluetooth-client-glue.{c,h} || die
	fi
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	local udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	insinto "${udevdir}"/rules.d
	doins "${FILESDIR}"/80-rfkill.rules
}

pkg_postinst() {
	gnome2_pkg_postinst
	# Notify about old libraries that might still be around
	preserve_old_lib_notify /usr/$(get_libdir)/libgnome-bluetooth.so.7

	elog "Don't forget to add yourself to the plugdev group "
	elog "if you want to be able to control bluetooth transmitter."
}
