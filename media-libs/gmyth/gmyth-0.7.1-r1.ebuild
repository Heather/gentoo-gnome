# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gmyth/gmyth-0.7.ebuild,v 1.4 2008/08/08 19:29:34 maekke Exp $
EAPI=4

inherit autotools eutils libtool

IUSE="debug static-libs"
LICENSE="LGPL-2"
DESCRIPTION="GObject based library to access mythtv backends"
HOMEPAGE="http://gmyth.sourceforge.net/"
SRC_URI="mirror://sourceforge/gmyth/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
RDEPEND="net-misc/curl
	dev-libs/glib
	dev-libs/libxml2
	|| ( dev-db/mysql[minimal] virtual/mysql )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# bug #386889; http://sourceforge.net/tracker/?func=detail&aid=3424822&group_id=177106&atid=879916
	epatch "${FILESDIR}/${PN}-0.7.1-types.h.patch"
	# http://sourceforge.net/tracker/?func=detail&aid=3424823&group_id=177106&atid=879916
	epatch "${FILESDIR}/${PN}-0.7.1-as-needed.patch"
	eautoreconf
}

src_configure() {
	econf $(use_enable debug) $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${D}" -name '*.la' -exec rm -f {} +
}
