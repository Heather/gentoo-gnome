# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libproxy/libproxy-0.4.6-r1.ebuild,v 1.2 2010/11/02 15:10:38 ssuominen Exp $

EAPI="2"
PYTHON_DEPEND="python? 2:2.5"

inherit cmake-utils eutils multilib python portability

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="gnome kde mono networkmanager perl python test vala xulrunner" #webkit

RDEPEND="
	gnome? ( gnome-base/gconf )
	kde? ( >=kde-base/kdelibs-4.3 )
	mono? ( dev-lang/mono )
	networkmanager? ( net-misc/networkmanager )
	perl? (	dev-lang/perl )
	vala? ( dev-lang/vala )
	xulrunner? ( >=net-libs/xulrunner-1.9.1:1.9 )"
	# Disable till we figure out how to fix problems with gtk2/gtk3 apps
	#webkit? ( net-libs/webkit-gtk:3 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS NEWS README ChangeLog"

PATCHES=( "${FILESDIR}"/${P}-mozjs-link_directory.patch )
		 # "${FILESDIR}"/${P}-webkit-gtk-3.patch )

pkg_setup() {
	if use python; then
		python_set_active_version 2
	fi
}

src_configure() {
	mycmakeargs=(
			-DPERL_VENDORINSTALL=ON
			-DCMAKE_C_FLAGS="${CFLAGS}"
			-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
			-DWITH_WEBKIT=OFF
			$(cmake-utils_use_with gnome GNOME)
			$(cmake-utils_use_with kde KDE4)
			$(cmake-utils_use_with mono DOTNET)
			$(cmake-utils_use_with networkmanager NM)
			$(cmake-utils_use_with perl PERL)
			$(cmake-utils_use_with python PYTHON)
			$(cmake-utils_use_with vala VALA)
			$(cmake-utils_use_with xulrunner MOZJS)
			$(cmake-utils_use test BUILD_TESTING)
	)
			#$(cmake-utils_use_with webkit WEBKIT)
	cmake-utils_src_configure
}

src_compile() {
	# Prevent access violation when building with mono support
	export MONO_SHARED_DIR="${T}/shared"
	cmake-utils_src_compile
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libproxy.so.0
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libproxy.so.0

	if use python; then
		python_need_rebuild
		python_mod_optimize $(python_get_sitedir)/${PN}.py
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup $(python_get_sitedir)/${PN}.py
	fi
}
