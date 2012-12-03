# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-good gst-plugins10

DESCRIPION="plugin to allow capture from video4linux2 devices"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="udev"

RDEPEND="
	media-libs/libv4l
	media-libs/gst-plugins-base:1.0[X]
	udev? ( >=virtual/udev-143[gudev] )
"
DEPEND="${RDEPEND}
	virtual/os-headers"

GST_PLUGINS_BUILD="gst_v4l2"

src_configure() {
	gst-plugins10_src_configure \
		--with-libv4l2 \
		$(use_with udev gudev)
}
