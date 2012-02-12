# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit gnome2

DESCRIPTION="Gnome account dialog"
HOMEPAGE="http://live.gnome.org/AccountsDialog"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	>=gnome-base/gnome-desktop-2:2
	>=dev-libs/libunique-1:1
	gnome-extra/polkit-gnome:obsolete
	>=gnome-base/gconf-2[policykit]
	>=media-video/cheese-2.30
	media-libs/gstreamer:0.10
	app-text/iso-codes
	app-admin/apg
	sys-apps/accountsservice
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40"

DOCS="AUTHORS NEWS README TODO"
