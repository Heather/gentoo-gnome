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
HOMEPAGE="https://live.gnome.org/Caribou"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-python/pygobject-2.27.92:2
	>=x11-libs/gtk+-2.91.8:3
	>=media-libs/clutter-1.5.11:1.0"
# gsettings-desktop-schemas is needed for the 'toolkit-accessibility' key
RDEPEND="${COMMON_DEPEND}
	dev-python/pyatspi
	dev-python/python-virtkey
	gnome-base/gsettings-desktop-schemas"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README"

src_install() {
	gnome2-python_src_install
	python_convert_shebangs -r 2 "${ED}"
}
