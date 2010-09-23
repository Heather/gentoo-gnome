# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup-gnome/libsoup-gnome-2.30.2.ebuild,v 1.7 2010/09/11 18:25:02 josejx Exp $

EAPI="2"

inherit autotools eutils gnome2

MY_PN=${PN/-gnome}
MY_P=${MY_PN}-${PV}

DESCRIPTION="GNOME plugin for libsoup"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI//-gnome}
	mirror://gentoo/${MY_PN}-2.30.1-build-gir-patches.tar.bz2"

LICENSE="LGPL-2"
SLOT="2.4"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-solaris"
# Do NOT build with --disable-debug/--enable-debug=no - gnome2.eclass takes care of that
IUSE="debug doc +introspection"

RDEPEND="~net-libs/libsoup-${PV}
	|| ( gnome-base/libgnome-keyring <gnome-base/gnome-keyring-2.29.4 )
	>=net-libs/libproxy-0.3
	>=gnome-base/gconf-2
	dev-db/sqlite:3
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/gtk-doc-am-1.10
	doc? ( >=dev-util/gtk-doc-1.10 )"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)
		--with-libsoup-system
		--with-gnome"
}

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index
	gnome2_src_configure
}

src_prepare() {
	gnome2_src_prepare

	# Fix test to follow POSIX (for x86-fbsd)
	# No patch to prevent having to eautoreconf
	sed -e 's/\(test.*\)==/\1=/g' -i configure.ac configure || die "sed failed"

	# Use lib present on the system
	epatch "${FILESDIR}"/${PN}-2.31.92-system-lib.patch
	eautoreconf
}
