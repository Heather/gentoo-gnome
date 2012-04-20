# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-utils/gnome-utils-2.32.0-r1.ebuild,v 1.1 2010/12/04 18:08:10 pacho Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Dictionary utility for GNOME 3"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1 FDL-1.1"
SLOT="0"
IUSE="doc ipv6"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
fi

COMMON_DEPEND=">=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0.0:3"

DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.22
	>=sys-devel/gettext-0.17
	doc? ( >=dev-util/gtk-doc-1.15 )"

pkg_setup() {
	DOCS="AUTHORS NEWS README TODO"
	G2CONF="--disable-schemas-compile
		$(use_enable ipv6)"
}
