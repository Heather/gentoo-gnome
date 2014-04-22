# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome3

DESCRIPTION="Evolution module for connecting to Kolab groupware servers"
HOMEPAGE="https://live.gnome.org/Evolution/Kolab"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE="" # kerberos (does nothing useful for now)

RDEPEND=">=mail-client/evolution-${PV}:2.0
	>=gnome-extra/evolution-data-server-${PV}
	>=dev-db/sqlite-3.7:3
	>=dev-libs/glib-2.32:2
	>=dev-libs/libical-0.44
	dev-libs/libxml2
	dev-libs/nss
	>=gnome-base/gconf-2:2
	>=net-misc/curl-7.19[ssl]
	>=x11-libs/gtk+-3.2:3
"
DEPEND="${RDEPEND}
	dev-util/gperf
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	virtual/pkgconfig
"
#	doc? (
#		app-text/docbook-xml-dtd:4.3
#		>=dev-util/gtk-doc-1.14 )
# eautoreconf needs gtk-doc-am

RESTRICT="test" # test suite is non-functional

myeconfargs=(
	"--without-krb5"
)
PATCHES=(
	"${FILESDIR}/${PN}-3.4.3-no-hello-world.patch"
	"${FILESDIR}/${PN}-3.5.5-no-tests.patch"
)

src_prepare() {
	# Strip stupid cflags
	sed -e 's/\(ADD_CFLAGS=.*\) -pedantic/\1/' \
		-i configure.ac configure || die

	gnome3_src_prepare
}

src_install() {
	gnome3_src_install
	rm -rv "${ED}usr/doc" || die "rm failed"
}
