# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Lightweight HTML Rendering/Printing/Editing Engine"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="3.14"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

# We keep bonobo until we can make sure no apps in tree uses
# the old composer code.
# TODO: gtk3
RDEPEND=">=x11-libs/gtk+-2.20
	>=x11-themes/gnome-icon-theme-2.22.0
	>=gnome-base/orbit-2
	>=app-text/enchant-1.1.7
	gnome-base/gconf:2
	>=app-text/iso-codes-0.49
	>=net-libs/libsoup-2.26.0:2.4"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40.0
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

pkg_setup() {
	ELTCONF="--reverse-deps"
	G2CONF="${G2CONF}
		--disable-static
		--disable-deprecated-warning-flags"
}
