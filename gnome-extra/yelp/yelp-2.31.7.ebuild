# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.30.1-r1.ebuild,v 1.1 2010/06/13 20:04:06 pacho Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="lzma"

RDEPEND="
	>=x11-libs/gtk+-2.90.5:3
	>=dev-libs/glib-2.25.11
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=dev-libs/dbus-glib-0.71
	>=gnome-extra/yelp-xsl-2.31.3
	>=net-libs/webkit-gtk-1.3.2:3.0
	app-arch/bzip2
	lzma? ( >=app-arch/xz-utils-4.9 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.41
	>=dev-util/pkgconfig-0.9"
# If eautoreconf:
#	gnome-base/gnome-common

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable lzma)"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.31.6-fix-gsettings-path.patch

	gnome2_src_prepare
}
