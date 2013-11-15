# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="GNOME thumbnailer utility which will generate a thumbnail for a directory"
HOMEPAGE="https://wiki.gnome.org/GnomeDirectoryThumbnailer"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="
	>=dev-libs/glib-2.35.0:2
	gnome-base/gnome-desktop:3=
	>=x11-libs/gdk-pixbuf-2.6:2
	virtual/pkgconfig"

src_prepare() {
	gnome2_src_prepare
}
