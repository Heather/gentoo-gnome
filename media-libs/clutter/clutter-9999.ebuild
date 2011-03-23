# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/clutter/clutter-9999.ebuild,v 1.3 2011/02/21 20:56:53 nirbheek Exp $

EAPI="2"
WANT_AUTOMAKE="1.11"
[[ ${PV} = 9999 ]] && GIT_ECLASS="autotools git"

inherit clutter ${GIT_ECLASS}

DESCRIPTION="Clutter is a library for creating graphical user interfaces"

SLOT="1.0"
IUSE="debug doc +introspection"
if [[ ${PV} = 9999 ]]; then
	EGIT_BOOTSTRAP="echo > build/config.rpath
		gtkdocize
		cp "${ROOT}/usr/share/gettext/po/Makefile.in.in" po/
		eautoreconf"
	EGIT_REPO_URI="git://git.clutter-project.org/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
	DEPEND=">=dev-util/gtk-doc-1.13"
else
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

# NOTE: glx flavour uses libdrm + >=mesa-7.3
# We always use the gdk-pixbuf backend now since it's been split out
RDEPEND="${RDEPEND}
	>=dev-libs/glib-2.26:2
	>=x11-libs/cairo-1.10
	>=x11-libs/pango-1.20[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=dev-libs/atk-1.17

	virtual/opengl
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXdamage
	x11-proto/inputproto
	>=x11-libs/libXi-1.3
	>=x11-libs/libXfixes-3
	>=x11-libs/libXcomposite-0.4

	|| ( x11-libs/gdk-pixbuf:2
		 >=x11-libs/gtk+-2.0:2 )

	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
DEPEND="${RDEPEND}
	${DEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	>=dev-util/gtk-doc-am-1.13
	doc? (
		>=dev-util/gtk-doc-1.13
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt )
"
DOCS="AUTHORS README NEWS ChangeLog*"

src_configure() {
	# We only need conformance tests, the rest are useless for us
	sed -e 's/^\(SUBDIRS =\).*/\1/g' \
		-i tests/Makefile.am || die "am tests sed failed"
	sed -e 's/^\(SUBDIRS =\).*/\1/g' \
		-i tests/Makefile.in || die "in tests sed failed"

	# XXX: Conformance test suite (and clutter itself) does not work under Xvfb
	# XXX: Profiling, coverage disabled for now
	# XXX: What about eglx/eglnative/opengl-egl-xlib/osx/wayland/etc flavours?
	#      Uses gudev-1.0 and libxkbcommon for eglnative/cex1000
	local myconf="
		--enable-debug=minimum
		--enable-cogl-debug=minimum
		--enable-conformance=no
		--disable-gcov
		--enable-profile=no
		--enable-maintainer-flags=no
		--enable-xinput
		--with-flavour=glx
		--with-imagebackend=gdk-pixbuf
		$(use_enable introspection)
		$(use_enable doc docs)"

	if use debug; then
		myconf="${myconf}
			--enable-debug=yes
			--enable-cogl-debug=yes"
	fi

	econf ${myconf}
}
