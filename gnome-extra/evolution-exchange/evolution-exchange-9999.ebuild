# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
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
IUSE="debug static"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
	IUSE="${IUSE} doc"
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=mail-client/evolution-${PV}:2.0
	>=gnome-extra/evolution-data-server-${PV}[ldap,kerberos]
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.0:3
	>=gnome-base/gconf-2:2
	>=dev-libs/libical-0.43
	dev-libs/libxml2:2
	net-libs/libsoup:2.4
	>=net-nds/openldap-2.1.30-r2
	virtual/krb5
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		doc? ( >=dev-util/gtk-doc-1.9 )"
fi

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"
	gnome2_src_configure \
		--with-krb5="${EPREFIX}"/usr \
		--with-openldap \
		--disable-static \
		$(use_enable debug e2k-debug) \
		$(use_with static static-ldap)
}
