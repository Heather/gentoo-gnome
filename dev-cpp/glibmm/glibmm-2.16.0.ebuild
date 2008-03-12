# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/glibmm/glibmm-2.14.2.ebuild,v 1.9 2007/12/11 11:03:26 vapier Exp $

inherit gnome2 eutils

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples"

RDEPEND=">=dev-libs/libsigc++-2.0.11
		 >=dev-libs/glib-2.16"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		doc? ( app-doc/doxygen )"

pkg_config() {
	DOCS="AUTHORS CHANGES ChangeLog NEWS README"
}

src_unpack() {
	gnome2_src_unpack

	if ! use examples; then
		# don't waste time building the examples
		sed -i 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' Makefile.in || die "sed failed"
	fi

	# GTime and time_t are equivalent on fbsd, so we cannot define both
	use x86-fbsd && epatch "${FILESDIR}/${P}-date.patch"
}

src_compile() {
	gnome2_src_configure
	perl -I tools/pm -- tools/gmmproc -I tools/m4 fileinputstream gio/src gio/giomm
	perl -I tools/pm -- tools/gmmproc -I tools/m4 fileoutputstream gio/src gio/giomm
	emake || die "compile failed"
}

src_install() {
	gnome2_src_install

	if ! use doc && ! use examples; then
		rm -fr "${D}/usr/share/doc/glibmm-2.4"
	fi

	if use examples; then
		find examples -type d -name '.deps' -exec rm -rf {} \; 2>/dev/null
		dodoc examples
	fi
}
