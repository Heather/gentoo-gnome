# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/swfdec-mozilla/swfdec-mozilla-0.5.5.ebuild,v 1.1 2007/12/22 10:24:35 pclouds Exp $

inherit multilib versionator

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Swfdec-mozilla is a decoder/renderer netscape style plugin for Macromedia Flash animations."
HOMEPAGE="http://swfdec.freedesktop.org/"
SRC_URI="http://swfdec.freedesktop.org/download/${PN}/${MY_PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="xulrunner"

DEPEND="
	dev-libs/glib:2
	=media-libs/swfdec-${PV}*
	xulrunner? ( net-libs/xulrunner )
	!xulrunner? ( || ( www-client/mozilla-firefox www-client/seamonkey ) )"
RDEPEND=""

pkg_setup() {
	if !built_with_use media-libs/swfdec soup ; then
		einfo "You must build swfdec with the soup USE flag to build"
		einfo "swfdec-gtk, which is required by swfdec-mozilla"
		die "Please re-emerge media-libs/swfdec with the soup USE flag"
	fi
}

src_compile() {
	econf --with-plugin-dir=/usr/$(get_libdir)/nsbrowser/plugins
	emake || die "emake failed"
}

src_install() {
		  exeinto /usr/$(get_libdir)/nsbrowser/plugins
		  doexe src/.libs/libswfdecmozilla.so || die "libswfdecmozilla.so failed"
		  insinto /usr/$(get_libdir)/nsbrowser/plugins
		  doins src/libswfdecmozilla.la
}
