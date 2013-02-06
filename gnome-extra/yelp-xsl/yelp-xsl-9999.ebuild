# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils gnome.org
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="XSL stylesheets for yelp"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2+ LGPL-2.1+ MIT FDL-1.1+"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
fi

RDEPEND=">=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.8"
# Requires gawk, not virtual/awk: nawk fails with syntax errors
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/itstool
	sys-apps/gawk
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.6.1-gawk.patch"
	sed -e 's/$(YELP_XSL_AWK)/gawk/' -i doc/yelp-xsl/Makefile.{am,in} || die
	default
}
