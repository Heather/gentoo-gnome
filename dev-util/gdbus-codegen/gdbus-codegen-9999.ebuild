# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME_ORG_MODULE="glib"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="xml"

inherit multilib python
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://git.gnome.org/${GNOME_ORG_MODULE}"
	inherit git-2
else
	inherit gnome.org
fi

DESCRIPTION="GDBus code and documentation generator"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-linux"
fi
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
# To prevent circular dependencies with glib[test]
PDEPEND=">=dev-libs/glib-${PV}:2"

S="${WORKDIR}/glib-${PV}/gio/gdbus-2.0/codegen"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs 2 gdbus-codegen.in
	sed -e "s:@libdir@:${EPREFIX}/usr/$(get_libdir):" \
		-i gdbus-codegen.in || die "sed gdbus-codegen.in failed"
	sed -e "s:\"/usr/local\":\"${EPREFIX}/usr\":" \
		-i config.py || die "sed config.py failed"
}

src_test() {
	elog "Skipping tests. This package is tested by dev-libs/glib"
	elog "when merged with FEATURES=test"
}

src_install() {
	insinto "/usr/$(get_libdir)/gdbus-2.0/codegen"

	# keep in sync with Makefile.am!
	doins __init__.py \
		codegen.py \
		codegen_main.py \
		codegen_docbook.py \
		config.py \
		dbustypes.py \
		parser.py \
		utils.py

	newbin gdbus-codegen.in gdbus-codegen

	doman "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1"
}

pkg_postinst() {
	python_need_rebuild
	python_mod_optimize /usr/$(get_libdir)/gdbus-2.0/codegen
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/gdbus-2.0/codegen
}
