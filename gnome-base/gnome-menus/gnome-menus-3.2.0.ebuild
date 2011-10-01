# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-menus/gnome-menus-2.30.5.ebuild,v 1.4 2011/01/30 18:40:38 armin76 Exp $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils gnome2 python

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2 LGPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

IUSE="debug +introspection python test"

COMMON_DEPEND=">=dev-libs/glib-2.29.15:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	python? (
		>=dev-libs/gobject-introspection-0.9.5
		dev-python/pygobject:3
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection] )"
# Older versions of slot 0 install the menu editor and the desktop directories
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-menus-3.0.1-r50:0"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	test? ( dev-libs/gjs )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	if use python || use introspection; then
		use introspection || ewarn "Enabling introspection due to USE=python"
		G2CONF="${G2CONF} --enable-introspection"
	else
		G2CONF="${G2CONF} --disable-introspection"
	fi

	G2CONF="${G2CONF} --disable-static"
}

src_prepare() {
	gnome2_src_prepare

	# Upstream patch to fix pygobject-3 compatibility, will be in next release
	epatch "${FILESDIR}/${P}-pygobject-3.patch"

	# Don't show KDE standalone settings desktop files in GNOME others menu
	epatch "${FILESDIR}/${PN}-3.0.0-ignore_kde_standalone.patch"

	# disable pyc compiling
	mv py-compile py-compile-disabled
	ln -s $(type -P true) py-compile

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

	# Prefix menu, bug #256614
	mv "${ED}"/etc/xdg/menus/applications.menu \
		"${ED}"/etc/xdg/menus/gnome-applications.menu || die "menu move failed"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-xdg-menu-gnome" || die "doexe failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_mod_optimize GMenuSimpleEditor
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm
	if use python; then
		python_mod_cleanup GMenuSimpleEditor
	fi
}
