# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pessulus/pessulus-2.16.4.ebuild,v 1.7 2008/05/29 15:30:17 hawking Exp $

inherit gnome2 multilib python

DESCRIPTION="lockdown editor for GNOME"
HOMEPAGE="http://live.gnome.org/Pessulus"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-python/pygtk-2.6.0
	>=dev-python/gnome-python-2.6.0
	>=dev-python/gnome-python-desktop-2.17.2
	>=gnome-base/gconf-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/Pessulus
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/Pessulus
}
