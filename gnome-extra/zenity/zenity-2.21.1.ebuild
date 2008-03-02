# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/zenity/zenity-2.20.1.ebuild,v 1.7 2008/02/04 04:36:08 jer Exp $

inherit gnome2

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="libnotify"

RDEPEND=">=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.8
	>=gnome-base/libglade-2
	>=gnome-base/libgnomecanvas-2
	>=dev-lang/perl-5
	libnotify? ( >=x11-libs/libnotify-0.4.1 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.14
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.10.1
	>=gnome-base/gnome-common-2.12.0"

DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper $(use_enable libnotify)"
}
