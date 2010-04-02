# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit eutils toolchain-funcs gnome2 python

DESCRIPTION="An API documentation browser for GNOME 2"
HOMEPAGE="http://live.gnome.org/devhelp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=gnome-base/gconf-2.6
	>=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.10
	>=x11-libs/libwnck-2.10
	>=net-libs/webkit-gtk-1.1.13
	>=dev-libs/libunique-1"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
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
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed 1 failed"

	# Fix build with older libunique, bug #286890
	sed -e 's/-DG.*_SINGLE_INCLUDES//' \
		-e 's/-DG.*_DEPRECATED//' \
		-i src/Makefile.am src/Makefile.in || die "sed 2 failed"
}

src_install() {
	gnome2_src_install
	# Internal library, punt .la file
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
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
