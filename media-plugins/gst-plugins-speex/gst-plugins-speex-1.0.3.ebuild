# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-good

DESCRIPTION="GStreamer plugin to allow encoding and decoding of speex"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/speex-1.1.6"
DEPEND="${RDEPEND}"
