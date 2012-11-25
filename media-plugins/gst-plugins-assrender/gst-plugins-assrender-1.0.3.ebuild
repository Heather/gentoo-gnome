# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for ASS/SSA rendering with effects support"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libass-0.9.4"
DEPEND="${RDEPEND}"
