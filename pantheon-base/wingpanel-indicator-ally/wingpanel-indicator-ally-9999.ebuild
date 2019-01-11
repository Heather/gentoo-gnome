# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_VERSION=0.22

inherit cmake-utils git-r3 gnome2-utils vala

DESCRIPTION="Accessibility indicator for Wingpanel"
HOMEPAGE="https://github.com/elementary/wingpanel-indicator-a11y"
EGIT_REPO_URI="https://github.com/elementary/wingpanel-indicator-a11y.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-libs/granite
	pantheon-base/wingpanel
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
"

src_prepare() {
	eapply_user

	vala_src_prepare
	cmake-utils_src_prepare
}


src_configure() {
	mycmakeargs=(
		-DVALA_EXECUTABLE=${VALAC}
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
