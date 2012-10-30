# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome.org

DESCRIPTION="Vendor logos for gnome-boxes"
HOMEPAGE="https://live.gnome.org/Design/Apps/Boxes"

LICENSE="UbuntuLogo DebianLogo RedhatLogo OpensuseLogo"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
