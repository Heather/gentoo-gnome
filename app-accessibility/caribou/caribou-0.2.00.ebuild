# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit gnome2-python

DESCRIPTION="Input assistive technology intended for switch and pointer users"
HOMEPAGE=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-python/pygobject-2.27.92:2
	dev-python/python-virtkey
	>=x11-libs/gtk+-2.91.8:3
	>=media-libs/clutter-1.5.11:1.0
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	app-text/gnome-doc-utils
"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	gnome2-python_pkg_setup
}

src_install() {
	gnome2-python_src_install
	python_convert_shebangs -r 2 "${ED}"
}
