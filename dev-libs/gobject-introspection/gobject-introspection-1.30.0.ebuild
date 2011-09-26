# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gobject-introspection/gobject-introspection-0.10.8.ebuild,v 1.10 2011/05/02 04:39:55 jer Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit gnome2 python
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Introspection infrastructure for generating gobject library bindings for various languages"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

IUSE="doc test"

RDEPEND=">=dev-libs/glib-2.29.7:2
	>=dev-libs/libffi-3.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/bison
	sys-devel/flex
	doc? ( >=dev-util/gtk-doc-1.15 )
	test? ( x11-libs/cairo )"

pkg_setup() {
	DOCS="AUTHORS CONTRIBUTORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable test tests)"

	python_set_active_version 2
}

src_prepare() {
	# Patch from upstream git master to fix g_irepository_get_c_prefix
	epatch "${FILESDIR}/${P}-c_prefix.patch"

	# FIXME: Parallel compilation failure with USE=doc
	use doc && MAKEOPTS="-j1"

	# Don't pre-compile .py
	ln -sf $(type -P true) py-compile
	ln -sf $(type -P true) build-aux/py-compile

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/g-ir-{annotation-tool,doc-tool,scanner}
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup /usr/lib*/${PN}/giscanner
}
