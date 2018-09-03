# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy )

inherit eutils virtualx python-r1 meson

SRC_URI="https://download.gnome.org/sources/pygobject/3.30/pygobject-${PV}.tar.xz"

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples test +cairo"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.46.0:=
	virtual/libffi:=
	>=dev-python/pycairo-1.11.1[${PYTHON_USEDEP}]
	x11-libs/cairo
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	x11-libs/cairo[glib]
	test? (
		dev-libs/atk[introspection]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		x11-libs/cairo[glib]
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
		python_targets_python2_7? ( dev-python/pyflakes[$(python_gen_usedep python2_7)] ) )
"

RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"
