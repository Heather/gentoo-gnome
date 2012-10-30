# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-exchange/evolution-exchange-2.32.2.ebuild,v 1.1 2011/02/07 11:40:13 pacho Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Evolution module for connecting to Microsoft Exchange"
HOMEPAGE="http://projects.gnome.org/evolution/"
LICENSE="GPL-2"

SLOT="1.0"
IUSE="doc"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	# XXX: re-enable keywords when libmapi can be emerged without black magick
	KEYWORDS="" #"~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

RDEPEND="
	>=mail-client/evolution-${PV}:2.0
	>=gnome-extra/evolution-data-server-${PV}
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-2.99.2:3
	>=net-libs/libmapi-1
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-static"

	# FIXME: Fix compilation flags crazyness
	sed 's/^\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure.ac configure || die "sed 1 failed"

	gnome2_src_prepare
}
