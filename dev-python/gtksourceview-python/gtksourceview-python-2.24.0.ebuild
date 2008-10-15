# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gtksourceview-python/gtksourceview-python-2.22.0.ebuild,v 1.2 2008/09/19 19:54:48 ford_prefect Exp $

G_PY_PN="gnome-python-desktop"

inherit gnome-python-common

DESCRIPTION="Python bindings for the gtksourceview (version 1.8) library"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples"

RDEPEND="=x11-libs/gtksourceview-1.8*
	>=dev-python/libgnomeprint-python-2.22.0
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/gtksourceview/*"

pkg_postinst() {
	elog
	elog "This package provides python bindings for x11-libs/gtksourceview-1.8."
	elog "If you want to 2.* python bindings, use dev-python/pygtksourceview-2"
}
