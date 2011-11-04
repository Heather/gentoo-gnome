# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_USE_WITH="xml"
PYTHON_DEPEND="2:2.5"

inherit base python
if [[ ${PV} = 9999 ]]; then
	inherit autotools git-2
fi

DESCRIPTION="Translation tool for XML documents that uses gettext files and ITS rules"
HOMEPAGE="http://itstool.org/"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://gitorious.org/itstool/itstool.git"
else
	SRC_URI="http://files.itstool.org/itstool/${P}.tar.bz2"
fi

# files in /usr/share/itstool/its are freedist
LICENSE="GPL-3 freedist"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE=""

RDEPEND="dev-libs/libxml2[python]"
DEPEND="${RDEPEND}"

pkg_setup() {
	DOCS=(ChangeLog NEWS) # AUTHORS, README are empty
}

src_prepare() {
	python_convert_shebangs -r 2 .
	[[ ${PV} = 9999 ]] && eautoreconf
}

src_compile() {
	default
	[[ ${PV} = 9999 ]] && emake ChangeLog
}
