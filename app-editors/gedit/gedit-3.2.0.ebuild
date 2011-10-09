# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.30.2.ebuild,v 1.1 2010/06/13 19:34:52 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_DEPEND="2"

inherit gnome2 python eutils virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc +introspection +python spell"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
fi

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=x11-libs/libSM-1.0
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.1.6:3[introspection?]
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
		>=dev-libs/gobject-introspection-0.9.3
		>=x11-libs/gtk+-3.0:3[introspection]
		>=x11-libs/gtksourceview-2.91.9:3.0[introspection]
		>=dev-libs/libpeas-0.7.4[gtk]
		>=dev-python/pygobject-2.90.2:3 )
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35
	)"

RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic"

DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=app-text/gnome-doc-utils-0.9.0
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )"
# gnome-common and gtk-doc-am needed to eautoreconf

pkg_setup() {
	DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"
	# TODO: Zeitgeist support, if GNOME 3 adds it to moduleset (3.2?)
	G2CONF="${G2CONF}
		--disable-zeitgeist
		--disable-deprecations
		--disable-maintainer-mode
		--disable-schemas-compile
		--disable-scrollkeeper
		--enable-updater
		--enable-gvfs-metadata
		$(use_enable introspection)
		$(use_enable python)
		$(use_enable spell)"

	if use python || use introspection; then
		python_set_active_version 2
	fi
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check || die "make check failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_mod_optimize /usr/$(get_libdir)/gedit/plugins
		# FIXME: take care of gi.overrides with USE=introspection
	fi

}

pkg_postrm() {
	gnome2_pkg_postrm
	if use python; then
		python_mod_cleanup /usr/$(get_libdir)/gedit/plugins
	fi
}
