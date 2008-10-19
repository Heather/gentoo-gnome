# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtk/pygtk-2.12.1-r2.ebuild,v 1.5 2008/08/12 13:30:34 armin76 Exp $

inherit autotools flag-o-matic gnome.org python subversion virtualx

ESVN_REPO_URI="http://svn.gnome.org/svn/${PN}/trunk"

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""
IUSE="doc examples"

RDEPEND=">=dev-libs/glib-2.8.0
	>=x11-libs/pango-1.16.0
	>=dev-libs/atk-1.12.0
	>=x11-libs/gtk+-2.13.6
	>=gnome-base/libglade-2.5.0
	>=dev-lang/python-2.4.4-r5
	>=dev-python/pycairo-1.0.2
	>=dev-python/pygobject-2.15.3
	!arm? ( dev-python/numeric )"

DEPEND="${RDEPEND}
	doc? ( dev-libs/libxslt >=app-text/docbook-xsl-stylesheets-1.70.1 )
	>=dev-util/pkgconfig-0.9"

src_unpack() {
	subversion_src_unpack

	AT_M4DIR="m4" eautoreconf

	# Fix declaration of codegen in .pc
	epatch "${FILESDIR}/${PN}-2.13.0-fix-codegen-location.patch"

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

src_compile() {
	use hppa && append-flags -ffunction-sections
	econf $(use_enable doc docs) --enable-thread

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog INSTALL MAPPING NEWS README THREADS TODO

	if use examples; then
		rm examples/Makefile*
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

src_test() {
	cd tests
	Xemake check-local || die "tests failed"
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/gtk-2.0
	rm -f "${ROOT}"/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.{py,pth}
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py pygtk.py-[0-9].[0-9]
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth pygtk.pth-[0-9].[0-9]
}
