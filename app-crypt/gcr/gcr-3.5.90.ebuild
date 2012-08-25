# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="debug doc +introspection"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
fi

COMMON_DEPEND=">=app-crypt/gnupg-2
	>=app-crypt/p11-kit-0.6
	>=dev-libs/glib-2.32:2
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
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	>=dev-util/gtk-doc-am-1.9

	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	dev-libs/gobject-introspection-common
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
		[[ ${PV} = 9999 ]] || eautoreconf
	fi

	gnome2_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}
