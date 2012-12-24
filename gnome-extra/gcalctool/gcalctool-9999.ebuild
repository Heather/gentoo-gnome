# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="http://live.gnome.org/Gcalctool http://calctool.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
fi

COMMON_DEPEND="
	>=x11-libs/gtk+-3:3
	>=dev-libs/glib-2.31:2
	dev-libs/libxml2:2
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gnome-utils-2.3"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools"
fi

src_configure() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"
	gnome2_src_configure
}
