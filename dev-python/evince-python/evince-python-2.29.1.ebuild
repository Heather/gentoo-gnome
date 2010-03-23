# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"
G_PY_PN="gnome-python-desktop"

inherit gnome-python-common

DESCRIPTION="Python bindings for the libwnck library"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=app-text/evince-2.29
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"
