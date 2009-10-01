# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/devhelp/devhelp-0.23.1.ebuild,v 1.2 2009/08/13 22:51:21 leio Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit eutils toolchain-funcs gnome2 gnome2-la python

DESCRIPTION="An API documentation browser for GNOME 2"
HOMEPAGE="http://live.gnome.org/devhelp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

# XXX: libunique dependency is due to #286890
# Check again with 2.28.0.2
RDEPEND=">=gnome-base/gconf-2.6
	>=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.10
	>=x11-libs/libwnck-2.10
	>=net-libs/webkit-gtk-1.1.13
	>=dev-libs/libunique-1.1.2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	# Internal library, punt .la file
	G2PUNT_LA="yes"

	# ICC is crazy, silence warnings (bug #154010)
	if [[ $(tc-getCC) == "icc" ]] ; then
		G2CONF="${G2CONF} --with-compile-warnings=no"
	fi
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	rm py-compile
	ln -s $(type -P true) py-compile

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_version
	python_need_rebuild
	python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins/devhelp
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/gedit-2/plugins/devhelp
}
