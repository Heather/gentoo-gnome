# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Location and timezone database and weather-lookup library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibGWeather"

LICENSE="GPL-2+"
SLOT="2/3-15" # subslot = 3-(libgweather-3 soname suffix)

IUSE="glade gtk-doc +introspection +vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.35.1:2
	>=x11-libs/gtk+-3.13.5:3[introspection?]
	>=net-libs/libsoup-2.44:2.4
	>=dev-libs/libxml2-2.6.0:2
	sci-geosciences/geocode-glib
	>=sys-libs/timezone-data-2010k

	glade? ( >=dev-util/glade-3.16:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.11
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use glade glade_catalog)
		$(meson_use vala enable_vala)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
