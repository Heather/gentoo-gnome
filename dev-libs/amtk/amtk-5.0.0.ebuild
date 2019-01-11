# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 multilib-minimal

DESCRIPTION="AMTK"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/gobject-introspection-0.6.7:=
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/gtk-doc-am
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	nls? ( >=sys-devel/gettext-0.19.2 )
"

src_prepare() {
	gnome2_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	gnome2_src_configure
}

multilib_src_install() {
	gnome2_src_install
}
