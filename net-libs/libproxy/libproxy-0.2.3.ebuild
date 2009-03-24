# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit autotools eutils python

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome kde networkmanager python webkit"

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
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19"

# dang: disable xulrunner until someone has time to figure out how to make it
# actually build.
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
		--without-mozjs \
		$(use_with gnome) \
		$(use_with kde) \
		$(use_with webkit) \
		$(use_with networkmanager) \
		$(use_with python)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed!"
	dodoc AUTHORS NEWS README ChangeLog || die "dodoc failed"
}

pkg_postinst() {
	if use python; then
		python_need_rebuild
		python_mod_optimize "$(python_get_sitedir)/${PN}.py"
	fi
}

pkg_postrm() {
	python_mod_cleanup "$(python_get_sitedir)/${PN}.py"
}
