# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-menus/gnome-menus-2.26.2.ebuild,v 1.2 2009/08/03 21:25:24 eva Exp $

inherit eutils gnome2 python

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug python"

RDEPEND=">=dev-libs/glib-2.18.0
	python? (
		>=dev-lang/python-2.4.4-r5
		dev-python/pygtk )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	# Do NOT compile with --disable-debug/--enable-debug=no
	# FIXME: fix autofoo and report upstream
	if use debug ; then
		G2CONF="${G2CONF} --enable-debug=yes"
	fi

	G2CONF="${G2CONF} $(use_enable python) --disable-static"
}

src_unpack() {
	gnome2_src_unpack

	# Don't show KDE standalone settings desktop files in GNOME others menu
	epatch "${FILESDIR}/${PN}-2.18.3-ignore_kde_standalone.patch"

	# disable pyc compiling
	mv py-compile py-compile-disabled
	ln -s $(type -P true) py-compile
}

src_install() {
	gnome2_src_install

	# Prefix menu, bug #256614
	mv "${D}"/etc/xdg/menus/applications.menu \
		"${D}"/etc/xdg/menus/gnome-applications.menu || die "menu move failed"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-xdg-menu-gnome" || die "doexe failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_version
		python_need_rebuild
		python_mod_optimize $(python_get_sitedir)/GMenuSimpleEditor
	fi

	ewarn "Due to bug #256614, you might loose icons in applications menus."
	ewarn "If you use a login manager, please re-select your session."
	ewarn "If you use startx and have no .xinitrc, just export XSESSION=Gnome."
	ewarn "If you use startx and have .xinitrc, export XDG_MENU_PREFIX=gnome-."
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/GMenuSimpleEditor
}
