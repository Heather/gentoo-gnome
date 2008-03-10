# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-desktop/gnome-python-desktop-2.20.0.ebuild,v 1.9 2008/02/10 22:04:04 eva Exp $

EAPI="1"

inherit gnome2 python virtualx

DESCRIPTION="provides python interfacing modules for some GNOME desktop libraries"
HOMEPAGE="http://pygtk.org/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc eds"

# FIXME: upstream is intending to move to WAF build system

RDEPEND="virtual/python
	>=dev-python/pygtk-2.10.3
	>=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.4.0
	>=dev-python/gnome-python-2.10.0
	>=gnome-base/gnome-panel-2.13.4
	>=gnome-base/libgnomeprint-2.2.0
	>=gnome-base/libgnomeprintui-2.2.0
	x11-libs/gtksourceview:1.0
	>=x11-libs/libwnck-2.19.3
	>=gnome-base/libgtop-2.13.0
	>=gnome-extra/nautilus-cd-burner-2.15.3
	>=gnome-extra/gnome-media-2.10.0
	>=gnome-base/gconf-2.10.0
	>=x11-wm/metacity-2.21.5
	dev-python/pycairo
	>=gnome-base/librsvg-2.13.93
	>=gnome-base/gnome-keyring-2.20.1
	>=gnome-base/gnome-desktop-2.10.0
	eds? ( >=gnome-extra/evolution-data-server-1.8 )
	>=media-video/totem-1.4.0
	!<dev-python/gnome-python-extras-2.13"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7"

DOCS="AUTHORS ChangeLog INSTALL* MAINTAINERS NEWS README"

pkg_config() {
	G2CONF="${G2CONF} $(use_enable eds evolution)"
}

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_test() {
	Xemake check || die "tests failed"
}

src_install() {
	gnome2_src_install

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
}
