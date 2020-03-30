# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org pax-utils virtualx meson

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo elibc_glibc examples test"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.58.0
	>=dev-libs/gobject-introspection-1.61.2:=
	>=dev-util/sysprof-3.33.3

	sys-libs/readline:0
	dev-lang/spidermonkey:60
	dev-libs/libffi:=
	cairo? ( x11-libs/cairo[X] )
"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus
			>=x11-libs/gtk+-3.20:3 )
"

RESTRICT="!test? ( test )"

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	local emesonargs=(
		$(meson_feature cairo)
		-Dreadline=enabled
		$(meson_feature elibc_glibc profiler)

		$(meson_use test installed_tests)
		-Dsystemtap=false
		-Ddtrace=false
		$(meson_use test skip_dbus_tests)
		$(meson_use test skip_gtk_tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}

src_test() {
	virtx emake check
}
