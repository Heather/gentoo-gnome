# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit autotools eutils gnome2 python
if [[ ${PV} = 9999 ]]; then
	GNOME_LIVE_MODULE="pyatspi2"
	inherit gnome2-live
fi

DESCRIPTION="Python binding to at-spi library"
HOMEPAGE="http://live.gnome.org/Accessibility"

# Note: only some of the tests are GPL-licensed, everything else is LGPL
LICENSE="LGPL-2 GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="test"

COMMON_DEPEND="dev-python/dbus-python
	>=dev-python/pygobject-2.90.1:3
"
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/dbus-1
	>=app-accessibility/at-spi2-core-${PV}[introspection]
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	test? (
		>=dev-libs/atk-2.1.0
		>=dev-libs/dbus-glib-0.7
		dev-libs/glib:2
		dev-libs/libxml2:2
		>=x11-libs/gtk+-2.10:2 )"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable test tests)"
	python_pkg_setup
}

src_prepare() {
	# remove pygtk cruft; https://bugzilla.gnome.org/show_bug.cgi?id=660826
	epatch "${FILESDIR}/${PN}-2.2.0-AM_CHECK_PYMOD-pygtk.patch"
	[[ ${PV} = 9999 ]] || eautoreconf

	gnome2_src_prepare

	# disable pyc compiling
	mv config/py-compile config/py-compile.orig
	ln -s $(type -P true) config/py-compile

	python_copy_sources
}

src_configure() {
	python_execute_function -s gnome2_src_configure
}

src_compile() {
	python_execute_function -s gnome2_src_compile
}

src_test() {
	python_execute_function -s -d
}

src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize pyatspi
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup pyatspi
}
