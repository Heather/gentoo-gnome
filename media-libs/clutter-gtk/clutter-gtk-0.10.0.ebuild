# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2 clutter

DESCRIPTION="Clutter-GTK - GTK+ Integration library for Clutter"

KEYWORDS="~amd64 ~x86"
IUSE="doc examples introspection"
SLOT="1.0"

RDEPEND="
	>=x11-libs/gtk+-2.12[X]
	media-libs/clutter:1.0[opengl]"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.11 )
	introspection? (
		media-libs/clutter[introspection]
		>=dev-libs/gobject-introspection-0.6.3
		>=dev-libs/gir-repository-0.6.3[gtk] )"

EXAMPLES=examples/{*.c,redhand.png}
G2CONF="${G2CONF}
	--with-flavour=x11
	--enable-maintainer-flags=no
	$(use_enable introspection)"
