# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils gst-plugins-good gst-plugins10

DESCRIPION="plugin to allow capture from video4linux2 devices"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="udev"

RDEPEND="
	media-libs/libv4l
	>=media-plugins/gst-plugins-xvideo-${PV}:${SLOT}
	udev? ( >=virtual/udev-143[gudev] )
"
DEPEND="${RDEPEND}
	virtual/os-headers"

GST_PLUGINS_BUILD="gst_v4l2"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.10.31-linux-headers-3.6.patch" #437012
}

src_configure() {
	gst-plugins10_src_configure \
		--with-libv4l2 \
		$(use_with udev gudev)
}
