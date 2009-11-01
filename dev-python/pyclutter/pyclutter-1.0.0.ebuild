# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit autotools python clutter

DESCRIPTION="Python bindings for Clutter"

KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

SLOT="1.0"
RDEPEND=">=dev-lang/python-2.5
	>=dev-python/pygtk-2.8.0
	>=dev-python/pycairo-1.0.2
	>=media-libs/clutter-1.0.0:${SLOT}"
DEPEND="${RDEPEND}
	doc? ( dev-libs/libxslt )"
EXAMPLES="examples/{*.py,*.png}"

# XXX: If eautoreconf, use AT_M4DIR=build/autotools
src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-docs-install-data-hook.patch"

	ln -sf $(type -P true) py-compile
}

src_configure() {
	local myconf="
		$(use_enable doc docs)"
	
	econf ${myconf}
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/clutter*
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup /usr/lib*/python*/site-packages/clutter*
}
