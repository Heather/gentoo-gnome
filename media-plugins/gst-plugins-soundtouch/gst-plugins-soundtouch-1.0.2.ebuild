# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer elements for beats-per-minute detection and pitch controlling"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libsoundtouch-1.4"
DEPEND="${RDEPEND}"
