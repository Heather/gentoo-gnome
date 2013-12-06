# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-live

DESCRIPTION="An IRC client for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari"
EGIT_REPO_URI="git://git.gnome.org/polari"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/gjs
	dev-libs/glib
	dev-libs/gobject-introspection
	>=x11-libs/gtk+-3.9.12
	net-libs/telepathy-glib"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.0"
