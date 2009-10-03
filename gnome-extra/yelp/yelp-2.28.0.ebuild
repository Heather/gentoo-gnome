# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.26.0.ebuild,v 1.3 2009/09/10 20:43:14 eva Exp $

EAPI="2"

inherit autotools eutils gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 -sparc ~x86"
IUSE="beagle lzma"

RDEPEND=">=gnome-base/gconf-2
	>=app-text/gnome-doc-utils-0.17.2
	>=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=x11-libs/startup-notification-0.8
	>=dev-libs/dbus-glib-0.71
	beagle? ( || (
		>=dev-libs/libbeagle-0.3.0
		=app-misc/beagle-0.2* ) )
	net-libs/xulrunner:1.9
	sys-libs/zlib
	app-arch/bzip2
	lzma? ( || (
		app-arch/xz-utils
		app-arch/lzma-utils ) )
	>=app-text/rarian-0.7
	>=app-text/scrollkeeper-9999"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	gnome-base/gnome-common"
# If eautoreconf:
#	gnome-base/gnome-common

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-gecko=libxul-embedding
		$(use_enable lzma)"

	if use beagle; then
		G2CONF="${G2CONF} --with-search=beagle"
	else
		G2CONF="${G2CONF} --with-search=basic"
	fi
}

src_prepare() {
	gnome2_src_prepare

	# Fix install_qa failure, bug #287132
	# Won't be needed in 2.28.1
	epatch "${FILESDIR}/${P}-include-warning-fix.patch"

	# Fix automagic lzma support, bug #266128
	epatch "${FILESDIR}/${PN}-2.26.0-automagic-lzma.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	# strip stupid options in configure, see bug #196621
	sed -i 's|$AM_CFLAGS -pedantic -ansi|$AM_CFLAGS|' configure || die "sed	failed"
}