# Copyrieht 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2 gnome2-la

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="http://blog.pierlux.com/projects/libchamplain/en/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk introspection" # python mono (not ported to clutter 1.0)

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/cairo-1.4
	>=net-libs/libsoup-2.26[gnome]

	media-libs/clutter:1.0
	dev-db/sqlite:3

	gtk? (
		>=x11-libs/gtk+-2.10
		>=media-libs/clutter-gtk-0.10:1.0 )"
# FIXME: add pyclutter and pyclutter-gtk first
#	python? (
#		dev-python/pygtk
#		dev-python/pyclutter
#		>=gnome-base/gconf-2 )
# FIXME: add clutter-sharp first
#	mono? (
#		>=dev-dotnet/gtk-sharp-2.12
#		>=dev-dotnet/gtk-sharp-gapi-2.12
#	)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"

pkg_setup() {
	G2PUNT_LA="yes"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)
		$(use_enable gtk)"
#		$(use_enable python)
#		$(use_enable mono managed"
}
