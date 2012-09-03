# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="libsecret is a library for storing and retrieving secrets such as passwords"
HOMEPAGE="https://live.gnome.org/Libsecret"

LICENSE="LGPL-2.1 Apache-2.0"
SLOT="0"
IUSE="+crypt debug doc +introspection"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=dev-libs/glib-2.31.0:2
	crypt? ( >=dev-libs/libgcrypt-1.2.2 )
	introspection? ( >=dev-libs/gobject-introspection-1.29 )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0
	>=dev-lang/vala-0.17.2.12:0.18
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	# VALAC is used by tests
	# VAPIGEN is used by libsecret
	G2CONF="
		--disable-maintainer-mode
		--enable-manpages
		--disable-strict
		--disable-coverage
		--disable-static
		$(use_enable crypt gcrypt)
		VALAC=$(type -P valac-0.18)
		VAPIGEN=$(type -P vapigen-0.18)"
}

src_test() {
	Xemake check
}

src_install() {
	gnome2_src_install
	prune_libtool_files --all
}
