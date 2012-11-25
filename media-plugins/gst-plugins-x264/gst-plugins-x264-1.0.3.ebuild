# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-ugly

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

# 20111220 ensures us X264_BUILD >= 120
RDEPEND=">=media-libs/x264-0.0.20111220"
DEPEND="${RDEPEND}"
