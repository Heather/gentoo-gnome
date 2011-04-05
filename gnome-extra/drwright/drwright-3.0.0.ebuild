# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome2

DESCRIPTION="A GNOME 3 tool that forces you to take regular breaks to prevent RSI"
HOMEPAGE="http://git.gnome.org/browse/drwright"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc ~ppc"
IUSE=""

RDEPEND=">=dev-libs/glib-2.26.0:2
	>=x11-libs/pango-1.2
	>=x11-libs/gtk+-3.0.0:3
	>=gnome-base/gnome-settings-daemon-2.91.8
	>=gnome-base/gnome-control-center-2.91.6
	>=x11-libs/libnotify-0.7
	media-libs/libcanberra[gtk3]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXScrnSaver"
DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.12.0"
DOCS="AUTHORS ChangeLog NEWS"
