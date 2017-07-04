# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bzr

DESCRIPTION="A set of wallpapers used by the elementary OS"
HOMEPAGE="http://www.elementaryos.org"
EBZR_REPO_URI="lp:~elementary-design/elementaryos/elementary-wallpapers"

LICENSE="CC-BY-NC-SA-2.5 CC-BY-3.0 CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	bzr_src_unpack
}

src_install() {
	insinto /usr/share/backgrounds/elementary
	doins *.jpg extra/*.jpg
}
