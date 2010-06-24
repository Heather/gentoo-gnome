# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit gnome.org

DESCRIPTION="XSL stylesheets for yelp"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.8"
DEPEND="${RDEPEND}
	sys-apps/gawk
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
