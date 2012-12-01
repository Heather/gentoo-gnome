# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-good

DESCRIPTION="GStreamer encoder/decoder for wavpack audio format"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-sound/wavpack-4.40"
DEPEND="${RDEPEND}"
