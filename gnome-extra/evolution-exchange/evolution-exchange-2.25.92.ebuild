# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-exchange/evolution-exchange-2.24.4.ebuild,v 1.3 2009/03/11 02:13:39 dang Exp $
EAPI=2

inherit eutils gnome2

DESCRIPTION="Evolution module for connecting to Microsoft Exchange"
HOMEPAGE="http://www.novell.com/products/desktop/features/evolution.html"
LICENSE="GPL-2"

SLOT="2.0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="debug doc static"

RDEPEND="
	>=mail-client/evolution-2.25.92
	>=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2.0
	>=gnome-base/libbonobo-2.20.3
	>=gnome-base/libglade-2.0
	>=gnome-base/libgnomeui-2.0
	dev-libs/libxml2
	net-libs/libsoup:2.4
	>=gnome-extra/evolution-data-server-2.25.92[ldap,kerberos]
	>=net-nds/openldap-2.1.30-r2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-openldap
		$(use_with debug e2k-debug)
		$(use_with static static-ldap)"
}

src_prepare() {
	# intltoolize because e-e won't install locales otherwise
	# thanks to recent intltool, no need to eautoreconf/eautomake
	intltoolize --force --copy --automake || die "intltoolize failed"
}
