# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

# clutter.eclass does not support .xz tarballs
inherit gnome2 versionator
if [[ ${PV} = 9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/clutter-project/mash.git"
	inherit gnome2-live
else
	RV=($(get_version_components))
	SRC_URI="http://source.clutter-project.org/sources/${PN}/${RV[0]}.${RV[1]}/${P}.tar.xz"
fi

DESCRIPTION="A library for rendering 3D models with Clutter"
HOMEPAGE="http://wiki.clutter-project.org/wiki/Mash"

LICENSE="LGPL-2.1"
SLOT="0.2"
IUSE="doc examples +introspection"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# Automagically detects x11-libs/mx, but only uses it for building examples.
# Note: mash is using a bundled copy of rply because mash developers have
# modified its API by adding extra arguments to various functions.
RDEPEND=">=dev-libs/glib-2.16:2
	>=media-libs/clutter-1.5.10:1.0[introspection?]
	virtual/opengl

	introspection? ( >=dev-libs/gobject-introspection-0.6.1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.14 )"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)"
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins example/{*.c,*.ply}
	fi
}
