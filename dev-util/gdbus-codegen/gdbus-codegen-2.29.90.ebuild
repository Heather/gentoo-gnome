# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME_ORG_MODULE="glib"
GNOME_TARBALL_SUFFIX="xz"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="xml"

inherit gnome.org multilib python

DESCRIPTION="GDBus code and documentation generator"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!!=dev-libs/glib-2.29.16"

# There is no good way to specify a block on a range of versions in an ebuild,
# hence the below horror. Remove it in early 2011-09, since by that time,
# hopefully overlay users will have upgraded to a compatible glib.
for (( i=4; i<16; i++ )); do
	RDEPEND="${RDEPEND} !!~dev-libs/glib-2.29.${i}"
done

S="${WORKDIR}/glib-${PV}/gio/gdbus-2.0/codegen"

src_prepare() {
	python_convert_shebangs 2 gdbus-codegen.in
	sed -e "s:@libdir@:${EPREFIX}/usr/$(get_libdir):" \
		-i gdbus-codegen.in || die "sed gdbus-codegen.in failed"
	sed -e "s:\"/usr/local\":\"${EPREFIX}/usr\":" \
		-i config.py || die "sed config.py failed"
}

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	insinto "/usr/$(get_libdir)/gdbus-2.0/codegen"
	# keep in sync with Makefile.am
	doins __init__.py \
		codegen.py \
		codegen_main.py \
		codegen_docbook.py \
		config.py \
		dbustypes.py \
		parser.py \
		utils.py || die "doins failed"
	newbin gdbus-codegen.in gdbus-codegen || die "dobin failed"
	doman "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1" ||
		die "doman failed"
}

src_test() {
	elog "Skipping tests. To test ${PN}, emerge dev-libs/glib"
	elog "with FEATURES=test"
}

pkg_postinst() {
	python_need_rebuild
	python_mod_optimize /usr/$(get_libdir)/gdbus-2.0/codegen
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/gdbus-2.0/codegen
}
