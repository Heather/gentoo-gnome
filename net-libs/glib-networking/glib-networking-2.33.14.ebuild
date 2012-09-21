# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="http://git.gnome.org/browse/glib-networking/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="+gnome +libproxy smartcard +ssl test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
fi

RDEPEND=">=dev-libs/glib-2.33.9:2
	gnome? ( gnome-base/gsettings-desktop-schemas )
	libproxy? ( >=net-libs/libproxy-0.4.6-r3 )
	smartcard? (
		>=app-crypt/p11-kit-0.8
		>=net-libs/gnutls-2.12.8[pkcs11] )
	ssl? (
		app-misc/ca-certificates
		>=net-libs/gnutls-2.11.0 )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	sys-devel/gettext
	test? ( sys-apps/dbus[X] )"
# eautoreconf needs >=sys-devel/autoconf-2.65:2.5

pkg_setup() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"
	G2CONF="${G2CONF}
		--disable-static
		--with-ca-certificates="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
		$(use_with gnome gnome-proxy)
		$(use_with libproxy)
		$(use_with smartcard pkcs11)
		$(use_with ssl gnutls)"
}

src_prepare() {
	gnome2_src_prepare

	if [[ ${PV} != 9999 ]]; then
		# Drop DEPRECATED flags
		LC_ALL=C sed -e 's:-D[A-Z_]*DISABLE_DEPRECATED *\\:\\:g' \
			-e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
			-i Makefile.{decl,in} \
			proxy/gnome/Makefile.in \
			proxy/libproxy/Makefile.in \
			proxy/tests/Makefile.in \
			tls/gnutls/Makefile.in \
			tls/pkcs11/Makefile.{am,in} \
			tls/tests/Makefile.in || die
		sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
			tls/pkcs11/Makefile.{am,in} || die
	fi
}

src_test() {
	Xemake check
}
