# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME_ORG_MODULE="glib"
PYTHON_COMPAT="python2_5 python2_6 python2_7 python3_1 python3_2"

inherit eutils python-distutils-ng
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://git.gnome.org/${GNOME_ORG_MODULE}"
	inherit git-2
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
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi
IUSE=""

RDEPEND="python_targets_python2_5? ( dev-lang/python:2.5[xml] )
	python_targets_python2_6? ( dev-lang/python:2.6[xml] )
	python_targets_python2_7? ( dev-lang/python:2.7[xml] )
	python_targets_python3_1? ( dev-lang/python:3.1[xml] )
	python_targets_python3_2? ( dev-lang/python:3.2[xml] )
"
DEPEND=""

# To prevent circular dependencies with glib[test]
PDEPEND=">=dev-libs/glib-${PV}:2"

S="${WORKDIR}/glib-${PV}/gio/gdbus-2.0/codegen"

python_prepare_all() {
	epatch "${FILESDIR}/${PN}-2.32.4-sitedir.patch"
	sed -e "s:\"/usr/local\":\"${EPREFIX}/usr\":" \
		-i config.py || die "sed config.py failed"

	mv gdbus-codegen.in gdbus-codegen || die "mv failed"
	cp "${FILESDIR}/setup.py-2.32.4" setup.py || die "cp failed"
	sed -e "s/@PV@/${PV}/" -i setup.py || die "sed setup.py failed"
}

src_test() {
	elog "Skipping tests. This package is tested by dev-libs/glib"
	elog "when merged with FEATURES=test"
}

python_install_all() {
	doman "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1"
}
