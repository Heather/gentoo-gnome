# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="http://live.gnome.org/libgdata"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.19.0
	>=net-libs/libsoup-2.24:2.4
	>=dev-libs/libxml2-2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"
G2CONF="${G2CONF} --disable-static"
