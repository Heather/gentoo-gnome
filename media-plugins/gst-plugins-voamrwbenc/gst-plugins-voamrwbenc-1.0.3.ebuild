# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for encoding AMR-WB"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/vo-amrwbenc-0.1"
DEPEND="${RDEPEND}"
