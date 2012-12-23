# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	VALA_MIN_API_VERSION="0.18"
	VALA_USE_DEPEND="vapigen"
	inherit gnome2-live vala
fi

DESCRIPTION="Disk usage browser for GNOME 3"
HOMEPAGE="https://live.gnome.org/GnomeUtils"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
fi

COMMON_DEPEND="
	>=dev-libs/glib-2.30.0:2
	gnome-base/libgtop:2=
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.5.9:3
	x11-libs/pango
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gsettings-desktop-schemas
	!<gnome-extra/gnome-utils-3.4
"
# ${PN} was part of gnome-utils before 3.4
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools
		$(vala_depend)"
fi

src_prepare() {
	if [[ ${PV} = 9999 ]]; then
		vala_src_prepare
	fi
}

src_configure() {
	if [[ ${PV} != 9999 ]]; then
		G2CONF="${G2CONF}
			ITSTOOL=$(type -P true)
			XMLLINT=$(type -P true)
			VALAC=$(type -P true)
			VAPIGEN=$(type -P true)"
	fi
	gnome2_src_configure
}
