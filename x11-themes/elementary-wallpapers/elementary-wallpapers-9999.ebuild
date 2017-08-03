# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A set of wallpapers used by the elementary OS"
HOMEPAGE="https://github.com/elementary/wallpapers"
EGIT_REPO_URI="https://github.com/elementary/wallpapers.git"

LICENSE="CC-BY-NC-SA-2.5 CC-BY-3.0 CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/backgrounds/elementary
	doins *.jpg
}
