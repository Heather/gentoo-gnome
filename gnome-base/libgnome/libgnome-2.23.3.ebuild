# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome/libgnome-2.22.0.ebuild,v 1.1 2008/03/22 22:57:09 eva Exp $

inherit gnome2

DESCRIPTION="Essential Gnome Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc esd"

RDEPEND=">=gnome-base/gconf-2
	>=dev-libs/glib-2.8
	>=gnome-base/gnome-vfs-2.5.3
	>=gnome-base/libbonobo-2.13
	>=dev-libs/popt-1.7
	esd? (
		>=media-sound/esound-0.2.26
		>=media-libs/audiofile-0.2.3
	)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --disable-schemas-install $(use_enable esd)"
}
