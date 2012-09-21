# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.18"

inherit gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live vala
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
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35.0
	doc? ( >=dev-util/gtk-doc-1.9 )"

# Only needed while regenerating from *.vala *.vapi
if [[ ${PV} = 9999 ]]; then
	DEPEND+="
		$(vala_depend)"
fi

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="
		--enable-manpages
		--disable-strict
		--disable-coverage
		--disable-static
		$(use_enable crypt gcrypt)"

	# Only needed while regenerating from *.vala *.vapi
	# VALAC is used by tests
	# VAPIGEN is used by libsecret
	if [[ ${PV} = 9999 ]]; then
		local vala_version="$(vala_best_api_version)"
		G2CONF="
			VALAC=$(type -P valac-${vala_version})
			VAPIGEN=$(type -P vapigen-${vala_version})"
	fi
}

src_prepare() {
	gnome2_src_prepare
}

src_test() {
	Xemake check
}

src_install() {
	gnome2_src_install
	prune_libtool_files --all
}
