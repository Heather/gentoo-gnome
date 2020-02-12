# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_USE_DEPEND=vapigen

PYTHON_COMPAT=( python3_{5,6,7} ) # python3_8 ready

inherit gnome.org meson eutils python-single-r1 vala virtualx

DESCRIPTION="A GObject plugins library"
HOMEPAGE="https://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="+gtk gtk-doc glade lua +python vala"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.39:=
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	gtk? ( >=x11-libs/gtk+-3:3[introspection] )
	lua? ( =dev-lang/lua-5.1*:0 )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.2:3[${PYTHON_MULTI_USEDEP}] )
"
BDEPEND="
	gtk-doc? ( >=dev-util/gtk-doc-am-1.11 )
	virtual/pkgconfig
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	vala? ( $(vala_depend) )
	>=dev-util/intltool-0.40
	gnome-base/gnome-common:3
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	vala_src_prepare

	default
}

src_configure() {
	local emesonargs=(
		-Dlua51=$(usex lua true false)
		-Dpython2=false
		-Dpython3=$(usex python true false)
		-Dintrospection=true
		-Dvapi=$(usex vala true false)
		-Dwidgetry=$(usex gtk true false)
		-Dglade_catalog=$(usex glade true false)
		-Ddemos=false
		-Dgtk_doc=$(usex gtk-doc true false)
	)

	meson_src_configure
}

src_test() {
	# This looks fixed since 1.18.0:
	#
	# FIXME: Tests fail because of some bug involving Xvfb and Gtk.IconTheme
	# DO NOT REPORT UPSTREAM, this is not a libpeas bug.
	# To reproduce:
	# >>> from gi.repository import Gtk
	# >>> Gtk.IconTheme.get_default().has_icon("gtk-about")
	# This should return True, it returns False for Xvfb
	virtx emake check
}
