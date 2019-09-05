# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools cargo git-r3

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg"

RESTRICT="mirror"
LICENSE="LGPL-2"
SLOT="2"
KEYWORDS=""

IUSE="gtk-doc introspection tools"

EGIT_REPO_URI="https://github.com/GNOME/librsvg.git"
#EGIT_BRANCH=""
#EGIT_COMMIT=""

RDEPEND=">=dev-libs/glib-2.34.3:2
	>=x11-libs/cairo-1.15.12
	>=x11-libs/pango-1.36.3
	>=dev-libs/libxml2-2.9.1-r4:2
	>=dev-libs/libcroco-0.6.8-r1
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
	tools? ( >=x11-libs/gtk+-3.10.0:3 )"

DEPEND="dev-libs/gobject-introspection-common
	dev-libs/vala-common
	>=dev-util/gtk-doc-am-1.13
	>=virtual/pkgconfig-0-r1
	gtk-doc? ( >=dev-util/gtk-doc-1.13 )"

BDEPEND=">=virtual/rust-1.37.0
	>=virtual/cargo-1.37.0"

# >=gtk-doc-am-1.13, gobject-introspection-common, vala-common needed by eautoreconf
# >=rust-1.37.0 needed for cargo vendoring to work

src_unpack() {
        if [[ "${PV}" == *9999* ]]; then
                git-r3_src_unpack
                cargo_live_src_unpack
        else
                cargo_src_unpack
        fi
}

src_prepare() {
	default

	local build_dir

        if [[ "${PV}" == *9999* ]]; then
	eautoreconf
	fi

}

src_configure() {
	local myconf=()

	ECONF_SOURCE=${S} \
	./configure \
	--prefix=/usr \
	--disable-static \
	--disable-tools \
		$(use_enable gtk-doc) \
		$(use_enable introspection) \
		--enable-pixbuf-loader \
		"${myconf[@]}"
}

src_compile() {
	default
}

src_install() {
	default
}
