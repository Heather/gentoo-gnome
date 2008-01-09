# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gtkhtml/gtkhtml-3.16.2.ebuild,v 1.1 2007/11/26 13:12:23 leio Exp $

inherit gnome2

DESCRIPTION="Lightweight HTML Rendering/Printing/Editing Engine"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="3.14"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="static"

RDEPEND=">=x11-libs/gtk+-2.10
	>=gnome-base/gail-1.1
	>=x11-themes/gnome-icon-theme-1.2
	>=gnome-base/libbonoboui-2.2.4
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/orbit-2
	>=gnome-base/libbonobo-2
	>=net-libs/libsoup-2.1.6"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35.5
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

pkg_setup() {
	ELTCONF="--reverse-deps"
	G2CONF="$(use_enable static) --enable-file-chooser"
}
