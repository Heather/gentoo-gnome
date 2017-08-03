# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="The official elementary GTK theme"
HOMEPAGE="https://github.com/elementary/stylesheet"
EGIT_REPO_URI="https://github.com/elementary/stylesheet.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+gtk +gtk3 +icons +wallpapers"

DEPEND="
	x11-themes/vanilla-dmz-aa-xcursors"
RDEPEND="${DEPEND}
	media-fonts/droid
	gtk? (
		x11-libs/gtk+:2
		x11-themes/gtk-engines-murrine
	)
	gtk3? (
		x11-libs/gtk+:3
		x11-themes/gtk-engines-unico
	)
	icons? (
		x11-themes/elementary-icon-theme
		x11-themes/hicolor-icon-theme
	)
	wallpapers? (
		x11-themes/elementary-wallpapers
	)"

RESTRICT="binchecks mirror strip"

DOCS=( AUTHORS CONTRIBUTORS COPYING )

src_install() {
	insinto /usr/share/themes/elementary
	doins -r index.theme gtk-2.0 gtk-3.0 gtk-3.22 plank

	base_src_install_docs
}
