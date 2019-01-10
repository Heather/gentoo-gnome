# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal meson vala

DESCRIPTION="Companion library to GObject and Gtk+"
HOMEPAGE="https://git.gnome.org/browse/libdazzle/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug +introspection"

RDEPEND="
	>=dev-libs/glib-2.58.0:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.24.1[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"

DEPEND="${RDEPEND}
	>=dev-util/meson-0.47.2
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-lang/vala
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	default
	vala_src_prepare
}
