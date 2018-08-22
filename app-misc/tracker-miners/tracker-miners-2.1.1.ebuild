# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_6 )

inherit meson gnome2

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE=""

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="app-misc/tracker"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"
PDEPEND=""
