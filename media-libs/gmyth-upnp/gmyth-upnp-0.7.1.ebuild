# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gmyth/gmyth-0.7.ebuild,v 1.4 2008/08/08 19:29:34 maekke Exp $

inherit libtool

IUSE="debug"
LICENSE="LGPL-2"
DESCRIPTION="GObject based library to access mythtv backends"
HOMEPAGE="http://gmyth.sourceforge.net/"
SRC_URI="mirror://sourceforge/gmyth/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
RDEPEND="net-libs/libupnp
	dev-libs/glib
	>=media-libs/gmyth-0.7"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf $(use_enable debug)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
