# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Evolution module for connecting to Kolab groupware servers"
HOMEPAGE="https://live.gnome.org/Evolution/Kolab"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE="" # doc (gtk-doc fails); kerberos (does nothing useful for now)

RDEPEND=">=mail-client/evolution-${PV}:2.0
	>=gnome-extra/evolution-data-server-${PV}
	>=dev-db/sqlite-3.7:3
	>=dev-libs/glib-2.32:2
	>=dev-libs/libical-0.44
	>=dev-libs/libxml2-2:2
	>=dev-libs/nss-3.12
	>=gnome-base/gconf-2:2
	>=net-libs/libsoup-2.36:2.4
	>=net-libs/libsoup-gnome-2.36:2.4
	>=net-misc/curl-7.19[ssl]
	>=x11-libs/gtk+-3.2:3
"
DEPEND="${RDEPEND}
	dev-util/gperf
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	virtual/pkgconfig
	dev-util/gtk-doc-am
"
#	doc? (
#		app-text/docbook-xml-dtd:4.3
#		>=dev-util/gtk-doc-1.14 )
# eautoreconf needs gtk-doc-am

RESTRICT="test" # test suite is non-functional

pkg_setup() {
	DOCS="AUTHORS NEWS"
	G2CONF="${G2CONF} --without-krb5" # --with-krb5 does nothing useful
}

src_prepare() {
	# We do not want to install a "hello world" program.
	epatch "${FILESDIR}/${PN}-3.4.3-no-hello-world.patch"
	# Disable test suite: parts fail, other parsts require connection to a live
	# kolab server, plus it installs test executables to /usr/bin
	epatch "${FILESDIR}/${PN}-3.5.5-no-tests.patch"
	[[ ${PV} = 9999 ]] || eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	rm -rv "${ED}usr/doc" || die "rm failed"
}
