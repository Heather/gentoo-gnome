# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils python

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome kde networkmanager python webkit xulrunner"

RDEPEND="
	gnome? ( 
		x11-libs/libX11 
		x11-libs/libXmu 
		gnome-base/gconf )
	kde? (
		x11-libs/libX11
		x11-libs/libXmu )
	networkmanager? ( net-misc/networkmanager )
	python? ( >=dev-lang/python-2.5 )
	webkit? ( net-libs/webkit-gtk )
	xulrunner? ( net-libs/xulrunner:1.9 )
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19"

src_prepare() {
	# http://code.google.com/p/libproxy/issues/detail?id=23
	epatch "${FILESDIR}/${P}-fix-dbus-includes.patch"
	# http://code.google.com/p/libproxy/issues/detail?id=24
	epatch "${FILESDIR}/${P}-fix-python-automagic.patch"
	# http://code.google.com/p/libproxy/issues/detail?id=25
	epatch "${FILESDIR}/${P}-fix-as-needed-problem.patch"

	eautoreconf
}

src_configure() {
	econf --with-envvar \
		--with-file \
		--disable-static \
		$(use_with gnome) \
		$(use_with kde) \
		$(use_with webkit) \
		$(use_with xulrunner mozjs) \
		$(use_with networkmanager) \
		$(use_with python)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed!"
	dodoc AUTHORS NEWS README ChangeLog || die "dodoc failed"
}

pkg_postinst() {
	if use python; then
		python_version
		python_need_rebuild
		python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages
	fi
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages
}
