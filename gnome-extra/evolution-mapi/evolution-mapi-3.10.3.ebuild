# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Evolution module for connecting to Microsoft Exchange"
HOMEPAGE="http://projects.gnome.org/evolution/"

LICENSE="|| ( LGPL-2 LGPL-3 )"
SLOT="1.0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	# XXX: re-enable keywords when libmapi can be emerged without black magick
	KEYWORDS="" #"~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

RDEPEND="
	>=mail-client/evolution-${PV}:2.0
	>=gnome-extra/evolution-data-server-${PV}
	>=dev-libs/glib-2.34:2
	>=x11-libs/gtk+-3:3
	>=net-libs/libmapi-2
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# FIXME: Fix compilation flags crazyness
	sed 's/^\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure.ac configure || die "sed 1 failed"

	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"
	gnome2_src_configure --disable-static
}
