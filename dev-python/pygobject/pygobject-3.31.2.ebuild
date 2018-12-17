# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )

inherit eutils virtualx python-r1 meson

SRC_URI="https://download.gnome.org/sources/pygobject/3.31/pygobject-${PV}.tar.xz"

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples +cairo"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.58.0:2
	>=dev-libs/gobject-introspection-1.58.0:=
	virtual/libffi:=
	>=dev-python/pycairo-1.17.0[${PYTHON_USEDEP}]
	x11-libs/cairo
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	x11-libs/cairo[glib]
	dev-libs/atk[introspection]
	x11-libs/cairo[glib]
	>=x11-libs/gdk-pixbuf-2.38.0:2[introspection]
	>=x11-libs/gtk+-3.24.0:3[introspection]
	x11-libs/pango[introspection]
"

RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"
