# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.22

inherit meson vala

DESCRIPTION="Mouse and touchpad settings"
HOMEPAGE="https://github.com/elementary/switchboard-plug-mouse-touchpad"
SRC_URI="https://github.com/elementary/switchboard-plug-mouse-touchpad/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/granite
	pantheon-base/switchboard
	x11-libs/gtk+:3	
"
DEPEND="${RDEPEND}
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

src_prepare() {
	eapply_user
	vala_src_prepare
}

