# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 python

DESCRIPTION="interactive Python accessibility explorer"
HOMEPAGE="http://live.gnome.org/Accerciser"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS="AUTHORS COPYING ChangeLog NEWS README"

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.8
	|| ( 
		>=dev-python/libbonobo-python-2.14
		>=dev-python/gnome-python-2.14 )
	>=dev-python/gnome-python-desktop-2.12
	>=dev-python/pyorbit-2.14
	>=gnome-extra/at-spi-1.7
	>=dev-libs/glib-2
	>=gnome-base/gconf-2"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.12"

pkg_setup() {
	G2CONF="--without-pyreqs"
}
