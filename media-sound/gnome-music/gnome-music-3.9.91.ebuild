# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools gnome2

DESCRIPTION="Music management for GNOME"
HOMEPAGE="https://git.gnome.org/browse/gnome-music/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

#media-plugins/grilo-plugins maybe optional
COMMON_DEPEND="
	>=dev-libs/glib-2.37:2
	>=x11-libs/gtk+-3.6.0:3
	>=media-libs/grilo-0.2.6
	media-plugins/grilo-plugins
"
RDEPEND="${COMMON_DEPEND}
	app-misc/tracker[gstreamer]
	>=gnome-base/gnome-settings-daemon-3.9.91
"
DEPEND="${COMMON_DEPEND}
"
