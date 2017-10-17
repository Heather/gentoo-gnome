# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python{3_4,3_5,3_6} )
PYTHON_REQ_USE="threads"

inherit meson gnome2 python-single-r1

DESCRIPTION="Media player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Videos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="debug +introspection lirc nautilus +python test zeitgeist vala doc"
# see bug #359379
REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	zeitgeist? ( introspection )
"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

# FIXME:
# Runtime dependency on gnome-session-2.91
RDEPEND="
	>=dev-libs/glib-2.35:2[dbus]
	>=dev-libs/libpeas-1.1[gtk]
	>=dev-libs/libxml2-2.6:2
	>=dev-libs/totem-pl-parser-3.10.1:0=[introspection?]
	>=media-libs/clutter-1.17.3:1.0[gtk]
	>=media-libs/clutter-gst-2.99.2:3.0
	>=media-libs/clutter-gtk-1.8.1:1.0
	>=x11-libs/cairo-1.14
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.19.4:3[introspection?]

	>=media-libs/grilo-0.3.0:0.3[playlist]
	media-plugins/grilo-plugins:0.3
	>=media-libs/gstreamer-1.6.0:1.0
	>=media-libs/gst-plugins-base-1.6.0:1.0[X,introspection?,pango]
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0

	x11-libs/libX11

	gnome-base/gnome-desktop:3=
	gnome-base/gsettings-desktop-schemas
	x11-themes/adwaita-icon-theme

	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
	lirc? ( app-misc/lirc )
	nautilus? ( >=gnome-base/nautilus-2.91.3 )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/libpeas-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=x11-libs/gtk+-3.5.2:3[introspection] 
		dev-python/pylint )
	zeitgeist? ( >=gnome-extra/zeitgeist-0.9.12 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xproto

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Denable-easy-codec-installation="yes" # Won’t compile if set to "no"
		-Denable-python=$(usex python yes no)
		-Denable-vala=$(usex vala yes no)
		-Dwith-plugins="auto" # Options are "all", "none" and "auto".
		-Denable-nautilus=$(usex nautilus yes no)
#		-Dwith-nautilusdir # string defining instalation path
		-Denable-gtk-doc=$(usex doc true false)
		-Denable-introspection=$(usex introspection yes no)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install
}
