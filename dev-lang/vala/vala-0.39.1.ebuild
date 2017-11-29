# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1"
SLOT="0.40"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/vala-common-${PV}
"

#TODO: slot install is a bit broken
DEPEND="${RDEPEND}
	!${CATEGORY}/${PN}:0
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2 )
	>=media-gfx/graphviz-2.40.1
	!dev-lang/vala:0.38
"

src_configure() {
	gnome2_src_configure --disable-unversioned
}

src_install() {
	emake DESTDIR="${D}" install
	dosym /usr/bin/vala-"${SLOT}" /usr/bin/vala
	dosym /usr/bin/vala-gen-introspect-"${SLOT}" /usr/bin/vala-gen-introspect
	dosym /usr/bin/valac-"${SLOT}" /usr/bin/valac
	dosym /usr/bin/valadoc-"${SLOT}" /usr/bin/valadoc
	dosym /usr/bin/vapicheck-"${SLOT}" /usr/bin/vapicheck
	dosym /usr/bin/vapigen-"${SLOT}" /usr/bin/vapigen
}
