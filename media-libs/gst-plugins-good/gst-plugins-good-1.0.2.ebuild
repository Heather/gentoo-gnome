# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-good/gst-plugins-good-0.10.31.ebuild,v 1.1 2012/10/23 07:55:22 tetromino Exp $

EAPI="5"
GST_ORC="yes"

# order is important, gst-plugins10 after gst-plugins-good
inherit eutils flag-o-matic gst-plugins-good gst-plugins10

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	app-arch/bzip2
	sys-libs/zlib
	orc? ( >=dev-lang/orc-0.4.16 )
"
DEPEND="${RDEPEND}
	=media-libs/gst-plugins-base-${PV}:${SLOT}
	>=dev-util/gtk-doc-am-1.12
"

DOCS="AUTHORS ChangeLog NEWS README RELEASE"

# Always enable optional bz2 support for matroska
# Always enable optional zlib support for qtdemux and matroska
# Many media files require these to work, as some container headers are often compressed, bug 291154
GST_PLUGINS_BUILD="bz2 zlib"

src_configure() {
	# gst doesnt handle optimisations well
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # see bug 22249

	gst-plugins10_src_configure \
		--disable-examples \
		--with-default-audiosink=autoaudiosink \
		--with-default-visualizer=goom
}

src_compile() {
	default
}

src_install() {
	default
	prune_libtool_files --modules
}
