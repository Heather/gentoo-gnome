# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="glib"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
PYTHON_REQ_USE="xml"
DISTUTILS_SINGLE_IMPL=1

SRC_URI=""
DESCRIPTION="GDBus code and documentation generator"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
"

# To prevent circular dependencies with glib[test]
PDEPEND=">=dev-libs/glib-2.59.2"

S="${WORKDIR}/glib-${PV}/gio/gdbus-2.0/codegen"
