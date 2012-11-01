# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-base gst-plugins10 toolchain-funcs

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-libs/libvisual-0.4
	>=media-plugins/libvisual-plugins-0.4"
DEPEND="${RDEPEND}"

src_prepare() {
	local alibs vlibs
	alibs="$($(tc-getPKG_CONFIG) --libs-only-l gstreamer-audio-${SLOT})"
	vlibs="$($(tc-getPKG_CONFIG) --libs-only-l gstreamer-video-${SLOT})"

	gst-plugins10_find_plugin_dir
	sed -e "s:\$(top_builddir)/gst-libs/gst/audio/.*\.la:${alibs}:" \
		-e "s:\$(top_builddir)/gst-libs/gst/video/.*\.la:${vlibs}:" \
		-i Makefile.am Makefile.in || die
}
