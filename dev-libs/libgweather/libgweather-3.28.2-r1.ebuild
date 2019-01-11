# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala meson

DESCRIPTION="Library to access weather information from online services"
HOMEPAGE="https://wiki.gnome.org/Projects/LibGWeather"

LICENSE="GPL-2+"
SLOT="2/15"  # subslot = 3-(libgweather-3 soname suffix)

IUSE="glade vala"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEPEND="
	>=x11-libs/gtk+-3.13.5:3
	>=dev-libs/glib-2.58.0:2
	>=net-libs/libsoup-2.44:2.4
	>=dev-libs/libxml2-2.6.0:2
	sci-geosciences/geocode-glib
	>=sys-libs/timezone-data-2010k
	glade? ( >=dev-util/glade-3.16:3.10 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		-Denable_vala=$(usex vala true false)
		-Dglade_catalog=$(usex glade true false)
	)
	meson_src_configure
}
