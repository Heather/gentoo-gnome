# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.22

inherit cmake-utils vala

DESCRIPTION="Switchboard plug to show displays information"
HOMEPAGE="https://github.com/elementary/switchboard-plug-display"
SRC_URI="https://github.com/elementary/switchboard-plug-display/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/granite
	gnome-base/gnome-desktop:3
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

	cmake-utils_src_prepare
	vala_src_prepare
}

