# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-exchange/evolution-exchange-2.32.2.ebuild,v 1.1 2011/02/07 11:40:13 pacho Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Evolution module for connecting to Microsoft Exchange"
HOMEPAGE="http://projects.gnome.org/evolution/"
LICENSE="GPL-2"

SLOT="2.0"
IUSE="debug doc static"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

RDEPEND="
	>=mail-client/evolution-${PV}:2.0
	>=gnome-extra/evolution-data-server-${PV}[ldap,kerberos]
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.0:3
	>=gnome-base/gconf-2:2
	dev-libs/libxml2:2
	net-libs/libsoup:2.4
	>=net-nds/openldap-2.1.30-r2
	virtual/krb5"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-krb5=${EPREFIX}/usr
		--with-openldap
		--disable-static
		--disable-maintainer-mode
		$(use_enable debug e2k-debug)
		$(use_with static static-ldap)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	gnome2_src_prepare

	# FIXME: Fix compilation flags crazyness
	sed 's/^\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure.ac configure || die "sed 1 failed"
}
