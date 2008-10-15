# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygobject/pygobject-2.14.2.ebuild,v 1.8 2008/08/12 13:28:49 armin76 Exp $

inherit autotools gnome2 python virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples libffi"

RDEPEND=">=dev-lang/python-2.4.4-r5
	>=dev-libs/glib-2.16
	!<dev-python/pygtk-2.13"
DEPEND="${RDEPEND}
	doc? ( dev-libs/libxslt >=app-text/docbook-xsl-stylesheets-1.70.1 )
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	if use libffi && ! built_with_use sys-devel/gcc libffi; then
		eerror "libffi support not found in sys-devel/gcc." && die
	fi

	G2CONF="${G2CONF} $(use_enable doc docs) $(use_with libffi)"
}

src_unpack() {
	gnome2_src_unpack

	# Fix FHS compliance, see upstream bug #535524
	epatch "${FILESDIR}/${P}-fix-codegen-location.patch"

	eautoreconf

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# Temporary test hack, upstream bug #550317
	#rm tests/test_subtype.py
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "tests failed"
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${P}
		doins -r examples
	fi

	python_version
	mv "${D}"/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py \
		"${D}"/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py-2.0
	mv "${D}"/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth \
		"${D}"/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth-2.0
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py pygtk.py-[0-9].[0-9]
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth pygtk.pth-[0-9].[0-9]
	python_mod_compile /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py

#	ewarn
#	ewarn "this release is not fully 64 bits safe, please do not use its"
#	ewarn "gio modules. If you can fix it, please look at upstream bug #550317"
#	ewarn
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
