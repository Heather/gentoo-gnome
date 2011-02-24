# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
VTE_PV="0.26.2" # check for changes in git to bump

inherit gnome.org base

DESCRIPTION="GNOME Setuid helper for opening ptys"
HOMEPAGE="http://git.gnome.org/browse/vte/"
# gnome-pty-helper is inside vte
SRC_URI="${SRC_URI//${PN}/vte}"
SRC_URI="${SRC_URI//${PV}/${VTE_PV}}"

LICENSE="LGPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

# gnome-pty-helper was spit out with 0.27.90
DEPEND=""
RDEPEND="!<x11-libs/vte-0.27.90"
S="${WORKDIR}/vte-${VTE_PV}/gnome-pty-helper"
