# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-exchange/evolution-exchange-2.26.3.ebuild,v 1.1 2009/07/23 21:46:43 eva Exp $

EAPI="2"

inherit autotools eutils gnome2

DESCRIPTION="Evolution module for connecting to Microsoft Exchange"
HOMEPAGE="http://www.novell.com/products/desktop/features/evolution.html"
LICENSE="GPL-2"

SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc64 ~x86"
IUSE="debug doc static"

RDEPEND="
	>=mail-client/evolution-2.28.0
	>=gnome-extra/evolution-data-server-2.28.0[ldap,kerberos]
	>=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2.0
	>=gnome-base/libbonobo-2.20.3
	>=gnome-base/libglade-2.0
	>=gnome-base/libgnomeui-2.0
	dev-libs/libxml2
	net-libs/libsoup:2.4
	>=net-nds/openldap-2.1.30-r2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-openldap
		--disable-static
		$(use_with debug e2k-debug)
		$(use_with static static-ldap)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix build with --as-needed, upstream bug #597489
	epatch "${FILESDIR}/${PN}-2.28.0-as-needed.patch"

	# FIXME: Fix compilation flags crazyness
	sed 's/CFLAGS="$CFLAGS $WARNING_FLAGS"//' \
		-i configure.ac configure || die "sed 1 failed"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}
