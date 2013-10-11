# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

GENTOO_DEPEND_ON_PERL="no"
inherit base eutils cmake-utils python-any-r1 multilib-minimal

DESCRIPTION="Library providing rendering capabilities for complex non-Roman writing systems"
HOMEPAGE="http://graphite.sil.org/"
SRC_URI="mirror://sourceforge/silgraphite/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		media-libs/fontconfig[${MULTILIB_USEDEP}]
		media-libs/silgraphite[${MULTILIB_USEDEP}]
		${PYTHON_DEPS}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-includes-libs-perl.patch"
	"${FILESDIR}/${PN}-1.0.2-no_harfbuzz_tests.patch"
	"${FILESDIR}/${PN}-1.0.3-no-test-binaries.patch"
	"${FILESDIR}/${PN}-1.2.0-solaris.patch"
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	base_src_prepare

	# make tests optional
	if ! use test; then
		sed -i \
			-e '/tests/d' \
			CMakeLists.txt || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=(
		"-DVM_MACHINE_TYPE=direct"
		# http://sourceforge.net/p/silgraphite/bugs/49/
		$([[ ${CHOST} == powerpc*-apple* ]] && \
			echo "-DGRAPHITE2_NSEGCACHE:BOOL=ON")
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	if use perl; then
		cd contrib/perl
		perl-module_src_prep
		perl-module_src_compile
	fi
}

multilib_src_test() {
	cmake-utils_src_test
}

multilib_src_install() {
	cmake-utils_src_install
	prune_libtool_files --all
}
