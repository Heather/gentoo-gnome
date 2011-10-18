# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.4"
PYTHON_USE_WITH="xml"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit gnome2-python

DESCRIPTION="Input assistive technology intended for switch and pointer users"
HOMEPAGE="https://live.gnome.org/Caribou"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-python/pygobject-2.90.3:3
	>=x11-libs/gtk+-3.0.0:3[introspection]
	x11-libs/gtk+:2
	>=dev-libs/gobject-introspection-0.10.7
	dev-libs/libgee:0
	dev-libs/libxml2
	>=media-libs/clutter-1.5.11:1.0[introspection]
	x11-libs/libX11
	x11-libs/libxklavier
	x11-libs/libXtst"
# gsettings-desktop-schemas is needed for the 'toolkit-accessibility' key
# pyatspi-2.1.90 needed to run caribou if pygobject:3 is installed
# librsvg needed to load svg images in css styles
RDEPEND="${COMMON_DEPEND}
	dev-python/dbus-python
	>=dev-python/pyatspi-2.1.90
	gnome-base/gconf[introspection]
	gnome-base/gsettings-desktop-schemas
	gnome-base/librsvg:2
	sys-apps/dbus"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.35.5
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	gnome2-python_pkg_setup
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		--disable-maintainer-mode
		--enable-gtk3-module
		--enable-gtk2-module
		VALAC=$(type -P true)"
	# vala is not needed for tarball builds, but configure checks for it...
}

src_prepare() {
	# delete custom PYTHONPATH, useless on Gentoo and potential bug source
	sed -e '/export PYTHONPATH=.*python/ d' \
		-i bin/{antler-keyboard,caribou,caribou-preferences}.in ||
		die "sed failed"

	gnome2-python_src_prepare
}

src_install() {
	gnome2-python_src_install
	python_convert_shebangs -r 2 "${ED}"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize caribou
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup caribou
}
