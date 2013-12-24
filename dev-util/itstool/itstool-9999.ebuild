# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="xml"

inherit python-single-r1
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

# files in /usr/share/itstool/its are HPND/as-is || GPL-3
LICENSE="GPL-3+ || ( HPND GPL-3+ )"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~arm-linux ~x86-linux"
fi
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libxml2[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

pkg_setup() {
	DOCS=(ChangeLog NEWS) # AUTHORS, README are empty
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .
	[[ ${PV} = 9999 ]] && eautoreconf
}

src_compile() {
	default
	[[ ${PV} = 9999 ]] && emake ChangeLog
}
