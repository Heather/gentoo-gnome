# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.26.2.ebuild,v 1.1 2010/11/19 22:00:44 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"
#PYTHON_DEPEND="python? 2:2.4"

inherit autotools eutils gnome2 #python

DESCRIPTION="Gnome terminal widget"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2.90"
IUSE="debug doc glade +introspection" #python
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
fi

# No python bindings (yet) with gtk+:3
RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-2.91.6:3
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses
	x11-libs/libX11
	x11-libs/libXft

	glade? ( dev-util/glade:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )

	!!<x11-libs/vte-0.26.2-r200"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.13 )
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-apps/sed
	sys-devel/gettext"

src_prepare() {
	G2CONF="${G2CONF}
		--disable-deprecation
		--disable-maintainer-mode
		--disable-schemas-compile
		--disable-static
		$(use_enable debug)
		$(use_enable glade glade-catalogue)
		$(use_enable introspection)
		--with-html-dir=${ROOT}/usr/share/doc/${PF}/html
		--with-gtk=3.0"
		#$(use_enable python)
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	#use python && python_set_active_version 2

	epatch "${FILESDIR}/${PN}-0.27.4-fix-gdk-targets.patch"

	[[ ${PV} != 9999 ]] && eautoreconf

	gnome2_src_prepare
}

#src_install() {
#	gnome2_src_install
#	python_clean_installation_image
#}
