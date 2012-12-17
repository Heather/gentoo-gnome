# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils gnome2 multilib python-single-r1 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/Gedit"

LICENSE="GPL-2+ CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
IUSE="+introspection +python spell zeitgeist"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~mips ~sh ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
fi

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=x11-libs/libSM-1.0
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.3.15:3[introspection?]
	>=x11-libs/gtksourceview-3.0.0:3.0[introspection?]
	>=dev-libs/libpeas-1.1.0[gtk]

	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM

	net-libs/libsoup:2.4

	introspection? ( >=dev-libs/gobject-introspection-0.9.3 )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/gobject-introspection-0.9.3
		>=x11-libs/gtk+-3:3[introspection]
		>=x11-libs/gtksourceview-3.6:3.0[introspection]
		dev-python/pycairo
		>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}] )
	spell? (
		>=app-text/enchant-1.2:=
		>=app-text/iso-codes-0.35 )
	zeitgeist? ( dev-libs/libzeitgeist )"
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=app-text/scrollkeeper-0.3.11
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
# yelp-tools, gnome-common needed to eautoreconf

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		doc? ( >=dev-util/gtk-doc-1 )
		app-text/yelp-tools"
fi

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"
	G2CONF="${G2CONF}
		--disable-deprecations
		--enable-updater
		--enable-gvfs-metadata
		$(use_enable introspection)
		$(use_enable python)
		$(use_enable spell)
		$(use_enable zeitgeist)"
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"

	gnome2_src_prepare
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	unset DBUS_SESSION_BUS_ADDRESS
	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}
