# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base git

DESCRIPTION="High-level convenience libraries and plugins for GStreamer"
HOMEPAGE="http://blogs.gnome.org/edwardrv/2009/11/30/the-result-of-the-past-few-months-of-hacking/"
EGIT_REPO_URI="git://git.collabora.co.uk/git/user/edward/gst-convenience.git"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-libs/gstreamer-0.10.25
	>=media-libs/gst-plugins-base-0.10.25"
RDEPEND="${DEPEND}"

EGIT_BOOTSTRAP="autogen.sh"

src_install() {
	base_src_install
	dodoc README AUTHORS || die "dodoc failed"
}
