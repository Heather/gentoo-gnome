# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Liboobs is a wrapping library to the System Tools Backends."
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.6.0
	>=app-admin/system-tools-backends-2.1.2
	>=dev-libs/dbus-glib-0.70"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS README"
