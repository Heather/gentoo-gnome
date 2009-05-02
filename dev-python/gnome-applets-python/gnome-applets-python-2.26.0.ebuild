# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-applets-python/gnome-applets-python-2.24.1.ebuild,v 1.1 2009/01/08 23:37:01 eva Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="applet"

inherit gnome-python-common

DESCRIPTION="Python bindings for writing GNOME applets"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=gnome-base/gnome-panel-2.13.4
	>=dev-python/libbonobo-python-2.22.0
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/applet/*"

src_unpack() {
	gnome-python-common_src_unpack

	# Fix session management of python applets, upstream bug #579390.
	epatch "${FILESDIR}/${P}-session-mgmt.patch"
}

