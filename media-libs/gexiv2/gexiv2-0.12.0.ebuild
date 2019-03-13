# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit eutils multilib python-r1 toolchain-funcs versionator xdg-utils meson

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="GObject-based wrapper around the Exiv2 library"
HOMEPAGE="https://wiki.gnome.org/Projects/gexiv2"
SRC_URI="mirror://gnome/sources/${PN}/${MY_PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="introspection python static-libs test"

REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	test? ( python )
"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.26.1:2
	>=media-gfx/exiv2-0.21:0=
	introspection? ( dev-libs/gobject-introspection:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

