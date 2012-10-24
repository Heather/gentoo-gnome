# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
VALA_MIN_API_VERSION=0.18
VALA_USE_DEPEND=vapigen

inherit eutils gnome2 python vala virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GObject library for accessing the freedesktop.org Secret Service API"
HOMEPAGE="https://live.gnome.org/Libsecret"

LICENSE="LGPL-2.1+ Apache-2.0" # Apache-2.0 license is used for tests only
SLOT="0"
IUSE="+crypt debug +introspection test vala"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

COMMON_DEPEND="
	>=dev-libs/glib-2.31.0:2
	crypt? ( >=dev-libs/libgcrypt-1.2.2 )
	introspection? ( >=dev-libs/gobject-introspection-1.29 )"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-keyring-3"
# Add ksecrets to RDEPEND when it's added to portage
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
	test? ( introspection? (
		=dev-lang/python-2*
		>=dev-libs/gjs-1.32
		dev-python/pygobject:3
	) )
	vala? ( $(vala_depend) )"

# Required while regenerating from *.vala *.vapi
if [[ ${PV} = 9999 ]]; then
	DEPEND+="
		$(vala_depend)
		doc? ( >=dev-util/gtk-doc-1.9 )"
fi

pkg_setup() {
	# python is only needed for tests
	if use test && use introspection; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--enable-manpages
		--disable-strict
		--disable-coverage
		--disable-static
		$(use_enable crypt gcrypt)
		$(use_enable introspection)
		$(use_enable vala)"

	if use vala || [[ ${PV} = 9999 ]]; then
		vala_src_prepare
	fi
	gnome2_src_prepare
}

src_test() {
	Xemake check
}

src_install() {
	gnome2_src_install
	prune_libtool_files --all
}
