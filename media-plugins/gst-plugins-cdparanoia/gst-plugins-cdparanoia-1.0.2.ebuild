# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-base gst-plugins10 toolchain-funcs

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-sound/cdparanoia-3.10.2-r3"
DEPEND="${RDEPEND}"

src_prepare() {
	local libs
	libs="$($(tc-getPKG_CONFIG) --libs-only-l gstreamer-audio-${SLOT})"

	gst-plugins10_find_plugin_dir
	sed -e "s:\$(top_builddir)/gst-libs/gst/audio/.*\.la:$libs:" \
		-i Makefile.am Makefile.in || die
}
