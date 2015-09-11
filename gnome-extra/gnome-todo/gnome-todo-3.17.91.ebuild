# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Gnome TODO"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/GnomeTodo"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection"

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.16.1:3[introspection?]
	>=gnome-base/gsettings-desktop-schemas-3.4
"
# g-s-d, gnome-desktop, gnome-shell etc. needed at runtime for the gsettings schemas
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-desktop-3.6.0.1:3=[introspection]
	gnome-base/gnome-shell
"
DEPEND="${COMMON_DEPEND}"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		PYTHON3_CONFIG=${PYTHON}-config
}
