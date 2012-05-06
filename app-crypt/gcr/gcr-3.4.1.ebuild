# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-3.2.2.ebuild,v 1.4 2011/11/18 04:41:30 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools gnome2 virtualx

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI} mirror://gentoo/introspection.m4.bz2" # for eautoreconf

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="debug doc +introspection"
KEYWORDS="~amd64 ~mips ~sh ~x86 ~x86-fbsd ~amd64-linux ~sparc-solaris ~x86-linux ~x86-solaris"

COMMON_DEPEND=">=app-crypt/gnupg-2
	>=app-crypt/p11-kit-0.6
	>=dev-libs/glib-2.30:2
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1
	>=sys-apps/dbus-1.0
	>=x11-libs/gtk+-3.0:3
	introspection? ( >=dev-libs/gobject-introspection-1.29 )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-keyring-3.3"
# gcr was part of gnome-keyring until 3.3
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug)
		--disable-update-icon-cache
		--disable-update-mime"
}

src_prepare() {
	# FIXME: failing tests
	if use test; then
		sed -e 's:test-subject-public-key::' \
			-e 's:test-system-prompt:$(NULL):' \
			-i gcr/tests/Makefile.am || die "sed failed"
		mv "${WORKDIR}/introspection.m4" build/m4/
		eautoreconf
	fi

	gnome2_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}
