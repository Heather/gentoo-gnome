# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/deskbar-applet/deskbar-applet-2.20.3.ebuild,v 1.10 2008/02/15 14:49:56 dang Exp $

inherit gnome2 eutils autotools python

DESCRIPTION="An Omnipresent Versatile Search Interface"
HOMEPAGE="http://raphael.slinckx.net/deskbar/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="eds spell"

RDEPEND=">=dev-lang/python-2.4
		 >=x11-libs/gtk+-2.10
		 >=dev-python/pygtk-2.10
		 >=dev-python/gnome-python-2.10
		 >=gnome-base/gnome-desktop-2.10
		 >=dev-python/dbus-python-0.80.2
		 >=dev-python/gnome-python-desktop-2.14.0
		 >=dev-python/gnome-python-extras-2.14
		 >=gnome-base/gconf-2
		 eds? ( >=gnome-extra/evolution-data-server-1.7.92 )
		 spell? ( >=gnome-extra/gnome-utils-2.16.2 )"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/intltool-0.35
		>=sys-devel/autoconf-2.60
		 app-text/gnome-doc-utils
		dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable eds evolution) --exec-prefix=/usr --disable-scrollkeeper"
}

src_unpack() {
	gnome2_src_unpack

	# Fix installing libs into pythondir
	epatch "${FILESDIR}"/${PN}-2.19.5-multilib.patch

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	AT_M4DIR="m4" eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst

	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/deskbar
	python_mod_optimize /usr/$(get_libdir)/deskbar-applet/modules-2.20-compatible

	ebeep 5
	ewarn "The dictionary plugin in deskbar-applet uses the dictionary from "
	ewarn "gnome-utils.  If it is not present, the dictionary plugin will "
	ewarn "fail silently."
	epause 5
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_version
	python_mod_cleanup
}
