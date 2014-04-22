# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{6,7} )

inherit eutils gnome3 python-single-r1

DESCRIPTION="Tool to customize GNOME 3 options"
HOMEPAGE="https://wiki.gnome.org/GnomeTweakTool"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=gnome-base/gsettings-desktop-schemas-3.4
	>=dev-python/pygobject-3.2.1:3[${PYTHON_USEDEP}]
"
# g-s-d, gnome-desktop, gnome-shell etc. needed at runtime for the gsettings schemas
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-desktop-3.6.0.1:3=[introspection]
	>=x11-libs/gtk+-3.9.10:3[introspection]

	net-libs/libsoup[introspection]
	x11-libs/libnotify[introspection]

	>=gnome-base/gnome-settings-daemon-3
	gnome-base/gnome-shell
	>=gnome-base/nautilus-3
	x11-wm/metacity
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-3.10.1-gentoo-cursor-themes.patch"
	"${FILESDIR}/${PN}-3.8.1-wm-preferences.patch"
)

src_install() {
	gnome3_src_install
	python_doscript gnome-tweak-tool || die
}
