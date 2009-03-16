# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libgnome-python/libgnome-python-2.25.90.ebuild,v 1.1 2008/09/26 10:02:48 leio Exp $

G_PY_PN="gnome-python"
G_PY_BINDINGS="gnome gnomeui"

inherit gnome-python-common

DESCRIPTION="Python bindings for essential GNOME libraries"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=gnome-base/libgnome-2.24.1
	>=gnome-base/libgnomeui-2.24.0
	>=dev-python/pyorbit-2.24.0
	>=dev-python/libbonobo-python-${PV}
	>=dev-python/gnome-vfs-python-${PV}
	>=dev-python/libgnomecanvas-python-${PV}
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES="examples/*
	examples/popt/*"
