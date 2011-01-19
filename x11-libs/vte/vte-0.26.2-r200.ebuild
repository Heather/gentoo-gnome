# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.26.2.ebuild,v 1.1 2010/11/19 22:00:44 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"
PYTHON_DEPEND="python? 2:2.4"

inherit gnome2 python

DESCRIPTION="Gnome terminal widget"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc glade +introspection python"

COMMON_DEPEND=">=dev-libs/glib-2.22:2
	>=x11-libs/gtk+-2.20:2
	>=x11-libs/pango-1.22.0
	sys-libs/ncurses
	glade? ( dev-util/glade:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	python? ( >=dev-python/pygtk-2.4 )
	x11-libs/libX11
	x11-libs/libXft"
RDEPEND="${COMMON_DEPEND}
	x11-libs/vte:2.90"
DEPEND="${COMMON_DEPEND}
	doc? ( >=dev-util/gtk-doc-1.13 )
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-deprecation
		--disable-static
		$(use_enable debug)
		$(use_enable glade glade-catalogue)
		$(use_enable introspection)
		$(use_enable python)
		--with-html-dir=${ROOT}/usr/share/doc/${PF}/html
		--with-gtk=2.0"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	use python && python_set_active_version 2
}

src_install() {
	gnome2_src_install
	python_clean_installation_image

	# Avoid clashing with SLOT=2.90
	rm -vf "${ED}/usr/libexec/gnome-pty-helper" || die
}
