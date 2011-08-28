# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.30.1-r1.ebuild,v 1.1 2010/06/13 20:04:06 pacho Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
# FIXME: gtk-doc scanner fails assertion in gtk_icon_theme_get_for_screen().
# How? Why?
IUSE="" # doc

# yelp-xsl-3.1.1 neded due to commit ee830ed9
RDEPEND="
	>=x11-libs/gtk+-2.91.8:3
	>=dev-libs/glib-2.25.11:2
	>=dev-libs/libxml2-2.6.5:2
	>=dev-libs/libxslt-1.1.4
	>=dev-libs/dbus-glib-0.71
	>=gnome-extra/yelp-xsl-3.1.1
	>=net-libs/webkit-gtk-1.3.2:3
	>=app-arch/xz-utils-4.9
	app-arch/bzip2
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.41.0
	>=dev-util/pkgconfig-0.9
	gnome-base/gnome-common"
#	doc? ( >=dev-util/gtk-doc-1.13 )
# If eautoreconf:
#	gnome-base/gnome-common

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		--enable-bz2
		--enable-lzma"
}

src_prepare() {
	# Fix compatibility with Gentoo's sys-apps/man
	# https://bugzilla.gnome.org/show_bug.cgi?id=648854
	epatch "${FILESDIR}/${PN}-3.0.3-man-compatibility.patch"

	eautoreconf

	gnome2_src_prepare
}
