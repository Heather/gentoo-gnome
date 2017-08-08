# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 multilib-minimal meson

DESCRIPTION="JSON RPC GLIB"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug +introspection"

RDEPEND="
	>=dev-libs/glib-2.53.4:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
