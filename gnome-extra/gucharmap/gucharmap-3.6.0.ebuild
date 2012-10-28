# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gucharmap/gucharmap-3.4.1.1.ebuild,v 1.1 2012/05/13 00:15:01 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="http://live.gnome.org/Gucharmap"

LICENSE="GPL-3"
SLOT="2.90"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cjk +introspection test"

COMMON_DEPEND="
	>=dev-libs/glib-2.32
	>=x11-libs/pango-1.2.1[introspection?]
	>=x11-libs/gtk+-3.4.0:3[introspection?]

	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gucharmap-3:0
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/gtk-doc-1
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )
"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)
		$(use_enable cjk unihan)"

	# prevent file collisions with slot 0
	sed -e "s:GETTEXT_PACKAGE=gucharmap$:GETTEXT_PACKAGE=gucharmap-${SLOT}:" \
		-i configure.ac configure || die "sed configure.ac configure failed"

	gnome2_src_prepare

	# avoid autoreconf
	sed -e 's/-Wall //g' -i configure || die "sed failed"
}
