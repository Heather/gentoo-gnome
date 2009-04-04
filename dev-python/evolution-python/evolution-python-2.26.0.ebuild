# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/evolution-python/evolution-python-2.24.1.ebuild,v 1.1 2009/01/08 23:34:39 eva Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="evolution evolution_ecal"

inherit gnome-python-common

DESCRIPTION="Python bindings for Evolution and Evolution Data Server"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=gnome-extra/evolution-data-server-1.2
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"
