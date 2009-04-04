# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-keyring-python/gnome-keyring-python-2.24.1.ebuild,v 1.1 2009/01/08 23:38:05 eva Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="gnomekeyring"

inherit gnome-python-common

DESCRIPTION="Python bindings for the interfacing with the GNOME keyring"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=gnome-base/gnome-keyring-0.5.0
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/keyring*"
