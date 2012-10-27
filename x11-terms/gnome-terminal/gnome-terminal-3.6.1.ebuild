# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

# FIXME: automagic dependency on gtk+[X]
RDEPEND=">=dev-libs/glib-2.26.0:2
	>=x11-libs/gtk+-3.3.17:3[X]
	>=x11-libs/vte-0.30.0:2.90
	>=gnome-base/gconf-2.31.3
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	x11-libs/libSM
	x11-libs/libICE"
# gtk+:2 needed for gtk-builder-convert, bug 356239
DEPEND="${RDEPEND}
	|| ( dev-util/gtk-builder-convert <=x11-libs/gtk+-2.24.10:2 )
	app-text/yelp-tools
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	# FIXME: leave smclient configure unset until it accepts values from the
	# switch and not from GDK_TARGET, bug #363033
	G2CONF="${G2CONF} --with-gtk=3.0"

	# Use login shell by default (#12900)
	epatch "${FILESDIR}"/${PN}-2.22.0-default_shell.patch

	gnome2_src_prepare
}
