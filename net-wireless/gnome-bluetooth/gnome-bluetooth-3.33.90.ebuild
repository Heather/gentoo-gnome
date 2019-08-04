# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 udev user meson

DESCRIPTION="Bluetooth graphical utilities integrated with GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeBluetooth"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="2/13" # subslot = libgnome-bluetooth soname version
IUSE="debug +introspection"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.38:2
	media-libs/libcanberra[gtk3]
	>=x11-libs/gtk+-3.12:3[introspection?]
	x11-libs/libnotify
	virtual/udev
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-5.50
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/meson-0.49.2
	!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.40.0
	dev-util/itstool
	virtual/libudev
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_configure() {
        local emesonargs=(
		-Denable-icon-update=false
		-Denable-introspection=$(usex introspection true false)
		-Denable-gtk-doc=true
        )
        meson_src_configure
}

pkg_setup() {
	enewgroup plugdev
}

src_install() {
	meson_src_install
	udev_dorules "${FILESDIR}"/61-${PN}.rules
}
