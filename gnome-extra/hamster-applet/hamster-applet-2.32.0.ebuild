# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/hamster-applet/hamster-applet-2.30.2-r1.ebuild,v 1.7 2010/10/09 14:35:40 ssuominen Exp $

EAPI="3"
GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="no"

inherit gnome2 python waf-utils

DESCRIPTION="Time tracking for the masses, in a GNOME applet"
HOMEPAGE="http://projecthamster.wordpress.com/"

# license on homepage is out-of-date, was changed to GPL-2 on 2008-04-16
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~sparc x86"
IUSE="eds libnotify"

RDEPEND=">=dev-lang/python-2.5[sqlite]
	dev-python/gconf-python
	dev-python/libgnome-python
	dev-python/libwnck-python
	dev-python/gnome-applets-python
	dev-python/gnome-desktop-python
	dev-python/dbus-python
	dev-python/pyxdg
	>=dev-python/pygobject-2.14
	>=dev-python/pygtk-2.12
	>=x11-libs/gtk+-2.12
	x11-libs/libXScrnSaver

	eds? ( dev-python/evolution-python )
	libnotify? ( dev-python/notify-python )
"
DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.17.3"

DOCS="AUTHORS NEWS README"

src_install() {
	waf-utils_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/*
	python_convert_shebangs 2 "${ED}"usr/$(get_libdir)/${PN}/${PN}
}

pkg_postinst() {
	gnome2_pkg_postinst

	python_need_rebuild
	python_mod_optimize hamster
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup hamster
}
