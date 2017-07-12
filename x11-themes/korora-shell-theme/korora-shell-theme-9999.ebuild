# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3
DESCRIPTION="a Korora tweaked Gnome shell theme"
HOMEPAGE="https://kororaproject.org"

SRC_URI=""
EGIT_REPO_URI="https://github.com/kororaproject/kp-gnome-shell-theme-korora.git"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"

DEPEND="gnome-extra/gnome-shell-extensions
	>=gnome-base/gnome-shell-3.10"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/themes/Korora
	doins -r upstream/gnome-shell
}
