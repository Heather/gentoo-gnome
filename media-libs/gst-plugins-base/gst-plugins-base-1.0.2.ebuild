# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-base/gst-plugins-base-0.10.36.ebuild,v 1.2 2012/10/23 08:10:00 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="alsa +introspection nls +ogg +orc +pango theora +vorbis X"
REQUIRED_USE="theora? ( ogg ) vorbis? ( ogg )"

RDEPEND=">=dev-libs/glib-2.32:2
	>=media-libs/gstreamer-${PV}:1.0[introspection?]
	dev-libs/libxml2:2
	sys-libs/zlib
	app-text/iso-codes
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	ogg? ( >=media-libs/libogg-1.0 )
	orc? ( >=dev-lang/orc-0.4.16 )
	pango? ( >=x11-libs/pango-1.22 )
	theora? ( >=media-libs/libtheora-1.1[encode] )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv )"

DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.11.5 )
	X? (
		x11-proto/videoproto
		x11-proto/xextproto
		x11-proto/xproto )"

src_prepare() {
	DOCS="AUTHORS NEWS README RELEASE"

	# The AC_PATH_XTRA macro unnecessarily pulls in libSM and libICE even
	# though they are not actually used. This needs to be fixed upstream by
	# replacing AC_PATH_XTRA with PKG_CONFIG calls.
	sed -i -e 's:X_PRE_LIBS -lSM -lICE:X_PRE_LIBS:' "${S}"/configure || die

	# bug #366931, flag-o-matic for the whole thing is overkill
	if [[ ${CHOST} == *86-*-darwin* ]] ; then
		sed -i \
			-e '/FLAGS = /s|-O[23]|-O1|g' \
			gst/audioconvert/Makefile \
			gst/volume/Makefile || die
	fi

	gnome2_src_prepare
}

src_configure() {
	econf \
		$(use_enable introspection) \
		$(use_enable nls) \
		$(use_enable orc) \
		$(use_enable alsa) \
		--disable-cdparanoia \
		--disable-libvisual \
		$(use_enable ogg) \
		$(use_enable pango) \
		$(use_enable theora) \
		$(use_enable vorbis) \
		--disable-ivorbis \
		$(use_enable X x) \
		$(use_enable X xshm) \
		$(use_enable X xvideo) \
		--disable-static \
		--disable-examples \
		--disable-freetypetest \
		--disable-debug \
		--with-package-name="Gentoo GStreamer Ebuild" \
		--with-package-origin="http://www.gentoo.org"
	# cdparanoia and libvisual are split out, per leio's request
}
