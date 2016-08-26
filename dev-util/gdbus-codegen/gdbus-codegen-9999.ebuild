# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GNOME_ORG_MODULE="glib"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="xml"

inherit eutils python-r1
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://git.gnome.org/${GNOME_ORG_MODULE}"
	inherit autotools git-2
else
	inherit gnome.org
fi

DESCRIPTION="GDBus code and documentation generator"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-libs/libxslt-1
	>=dev-util/gtk-doc-am-1.15
	>=sys-devel/gettext-0.11
"

# To prevent circular dependencies with glib[test]
PDEPEND=">=dev-libs/glib-${PV}:2"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.40.0-sitedir.patch"

	# Leave shebang alone
	sed -e 's:#!@PYTHON@:#!/usr/bin/env python:' \
		-i gio/gdbus-2.0/codegen/gdbus-codegen.in || die

	# Leave automake defaults do the work for us
	sed -e "s:\(codegendir =\).*:\1 \$(pyexecdir)/gdbus_codegen:" \
		-i gio/gdbus-2.0/codegen/Makefile.am || die

	eautoreconf

	prepare_python() {
		mkdir -p "${BUILD_DIR}"
	}
	python_foreach_impl prepare_python
}

src_configure() {
	ECONF_SOURCE="${S}" python_foreach_impl run_in_build_dir econf
}

src_compile() {
	python_foreach_impl run_in_build_dir emake -C gio/gdbus-2.0/codegen
	python_foreach_impl run_in_build_dir emake -C docs/reference/gio gdbus-codegen.1
}

src_test() {
	einfo "Skipping tests. This package is tested by dev-libs/glib"
	einfo "when merged with FEATURES=test"
}

src_install() {
	python_foreach_impl run_in_build_dir emake install -C gio/gdbus-2.0/codegen DESTDIR="${D}"
	python_foreach_impl run_in_build_dir doman docs/reference/gio/gdbus-codegen.1
	python_replicate_script "${ED}"/usr/bin/gdbus-codegen
}
