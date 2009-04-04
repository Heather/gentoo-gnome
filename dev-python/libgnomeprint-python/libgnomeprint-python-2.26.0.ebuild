# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libgnomeprint-python/libgnomeprint-python-2.24.1.ebuild,v 1.1 2009/01/08 23:40:18 eva Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="gnomeprint gnomeprintui"

inherit gnome-python-common

DESCRIPTION="Python bindings for GNOME printing support"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples"

RDEPEND=">=gnome-base/libgnomeprint-2.2.0
	>=gnome-base/libgnomeprintui-2.2.0
	>=dev-python/libgnomecanvas-python-2.25.90
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/gnomeprint/*"
