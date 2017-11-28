# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="plano theme for GNOME, Xfce and more."
HOMEPAGE="https://github.com/lassekongo83/plano-theme"
EGIT_REPO_URI="https://github.com/lassekongo83/plano-theme.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=x11-libs/gtk+-2:2
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/gdk-pixbuf-2:2
	x11-themes/gtk-engines-murrine"
RDEPEND="${DEPEND}"

src_install() {
	rm -rf LICENSE README.md plano.png .gitignore .gitattributes
	insinto /usr/share/themes/Plano
	doins -r *
}
