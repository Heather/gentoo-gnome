# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils gnome2 python virtualx

DESCRIPTION="The Gnome Accessibility Toolkit"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

LICENSE="LGPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-libs/atk-1.29.2
	>=x11-libs/gtk+-2.19.7
	>=gnome-base/libbonobo-1.107
	>=gnome-base/orbit-2
	>=dev-libs/dbus-glib-0.76
	>=gnome-base/gconf-2
	dev-libs/popt

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )

	x11-libs/libXt
	x11-proto/xextproto
	x11-proto/inputproto
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog NEWS README TODO"

# needs a live properly configured environment. Not really suited to
# an ebuild restricted environment
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-relocate
		--enable-sm
		--disable-xevie"
}

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# should fix tests
	epatch "${FILESDIR}"/${PN}-1.22.0-tests.patch

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_test() {
	Xemake check || die "Testing phase failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	python_need_rebuild
	python_mod_optimize $(python_get_sitedir)/pyatspi_corba
}

pkg_postrm() {
	gnome2_pkg_postrm

	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/pyatspi
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/pyatspi_corba
}
