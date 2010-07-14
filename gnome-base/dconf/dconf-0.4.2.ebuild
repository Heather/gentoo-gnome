# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit gnome2

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="http://live.gnome.org/dconf"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +introspection"

RDEPEND=">=dev-libs/glib-2.25.10
	>=dev-libs/libgee-0.5.1
	>=dev-libs/libxml2-2.7.7
	x11-libs/gtk+:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.9.2
	doc? ( >=dev-util/gtk-doc-1.14 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)"
}
