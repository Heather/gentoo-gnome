# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bug-buddy-python/bug-buddy-python-2.24.1.ebuild,v 1.1 2009/01/08 23:29:41 eva Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="bugbuddy"

inherit gnome-python-common

DESCRIPTION="Python bindings for Bug Buddy"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=gnome-extra/bug-buddy-2.16
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"
