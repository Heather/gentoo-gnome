# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package for GNOME 3, merge this package to install"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="2.0" # Cannot be installed at the same time as gnome-2

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE=""
S="${WORKDIR}"

RDEPEND="
	>=gnome-base/gdm-${PV}
	>=gnome-base/gnome-keyring-3.28.2
	>=gnome-base/gnome-session-${PV}
	>=gnome-extra/evolution-data-server-${PV}
"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.38.0"
