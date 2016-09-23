# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit gnome2 python-single-r1 toolchain-funcs versionator

DESCRIPTION="gnome-autoar"
HOMEPAGE="https://git.gnome.org/browse/gnome-autoar"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
IUSE=""
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# virtual/pkgconfig needed at runtime, bug #505408
# We force glib and goi to be in sync by this way as explained in bug #518424
RDEPEND="
	>=dev-libs/glib-2.$(get_version_component_range 2):2
	${PYTHON_DEPS}
"
# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	# To prevent crosscompiling problems, bug #414105
	gnome2_src_configure \
		--disable-static \
		CC="$(tc-getCC)" \
		YACC="$(type -p yacc)"
}

src_install() {
	gnome2_src_install
}
