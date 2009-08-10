# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"
WANT_AUTOMAKE="1.9"

inherit gnome2 clutter autotools

DESCRIPTION="Clutter is a library for creating graphical user interfaces"

KEYWORDS="~amd64 ~x86"
IUSE="debug doc +gtk introspection +opengl sdl"
SLOT="1.0"

RDEPEND="${RDEPEND}
	>=dev-libs/glib-2.16
	>=x11-libs/cairo-1.4
	>=x11-libs/pango-1.20
	
	gtk? ( >=x11-libs/gtk+-2.0 )
	opengl? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXdamage
		x11-libs/libXi
		x11-proto/inputproto

		>=x11-libs/libXfixes-3
		>=x11-libs/libXcomposite-0.4 )
	!opengl? ( sdl? ( media-libs/libsdl ) )
"
DEPEND="${RDEPEND}
	${DEPEND}
	doc? (
		>=dev-util/gtk-doc-1.11
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		app-text/xmlto )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.3
		>=dev-libs/gir-repository-0.6.3[pango] )"

pkg_setup() {
	local errmsg="Select either opengl or sdl as your renderer"

	if use opengl; then
		if use sdl; then
			ewarn "Both 'opengl' and 'sdl' USE flags selected"
			ewarn "Selecting opengl/glx (default)..."
		fi
		elog "Using GLX for OpenGL backend"
		G2CONF="${G2CONF} --with-flavour=glx"
	elif use sdl; then
		elog "Using SDL for OpenGL backend"
		G2CONF="${G2CONF} --with-flavour=sdl"
	else
		eerror "${errmsg}"
		die "${errmsg}"
	fi

	if use gtk; then
		G2CONF="${G2CONF} --with-imagebackend=gdk-pixbuf"
	else
		G2CONF="${G2CONF} --with-imagebackend=internal"
		# Internal image backend is experimental
		ewarn "You have selected the experimental internal image backend"
	fi

	if use debug; then
		G2CONF="${G2CONF}
			--enable-debug=yes
			--enable-cogl-debug=yes"
	fi

	# XXX: Tests are interactive, not of use for us
	# FIXME: Using external json-glib breaks introspection
	G2CONF="${G2CONF}
		--disable-tests
		--enable-maintainer-flags=no
		--enable-xinput
		--with-json=internal
		$(use_enable introspection)
		$(use_enable doc manual)"
}

src_prepare() {
	# Tests are interactive, not of use for us
	epatch "${FILESDIR}/${P}-disable-tests.patch"

	eautoreconf
}
