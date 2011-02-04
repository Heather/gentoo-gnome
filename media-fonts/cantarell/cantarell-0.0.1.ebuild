# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MY_PN="${PN}-fonts"

inherit font gnome.org

DESCRIPTION="Cantarell fonts, default fontset for GNOME Shell"
HOMEPAGE="http://abattis.org/cantarell/"
LICENSE="OFL-1.1"
SRC_URI="${SRC_URI//${PN}/${MY_PN}}"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="media-libs/fontconfig"
DEPEND=">=dev-util/pkgconfig-0.19"

DOCS="NEWS README"
S="${WORKDIR}/${MY_PN}-${PV}"

# Font eclass settings
FONT_CONF=("${S}/fontconfig/57-cantarell.conf")
FONT_S="${S}/otf"
FONT_SUFFIX="otf"
