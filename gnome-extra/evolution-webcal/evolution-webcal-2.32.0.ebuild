# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-webcal/evolution-webcal-2.28.1.ebuild,v 1.7 2010/10/09 15:14:44 ssuominen Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A GNOME URL handler for web-published ical calendar files"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=gnome-base/gconf-2
	net-libs/libsoup:2.4
	>=dev-libs/glib-2.8:2
	>=x11-libs/gtk+-2.18:2
	>=gnome-extra/evolution-data-server-1.10"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog TODO"
