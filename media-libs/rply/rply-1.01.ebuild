# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils

DESCRIPTION="A library to read and write PLY files"
HOMEPAGE="http://w3.impa.br/~diego/software/rply/"
SRC_URI="http://w3.impa.br/~diego/software/rply/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	use doc && HTML_DOCS="manual/*"
}

src_prepare() {
	# rply doesn't have *any* build system - not even a Makefile!
	# For simplicity, use the cmake file that Fedora maintainers have created
	cp "${FILESDIR}/rply_CMakeLists.txt" CMakeLists.txt
	mkdir -p CMake/export
}
