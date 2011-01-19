# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/gnome-terminal/gnome-terminal-2.32.1.ebuild,v 1.1 2010/11/19 22:17:31 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
fi

# libgnome needed for some monospace font schema, bug #274638
RDEPEND=">=dev-libs/glib-2.25.12:2
	>=x11-libs/gtk+-2.91.6:3
	>=gnome-base/gconf-2.31.3
	>=x11-libs/vte-0.27.3:2.90
	x11-libs/libSM
	x11-libs/libX11
	gnome-base/libgnome"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3.11
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_prepare() {
	G2CONF="${G2CONF}
		--with-smclient-backend=xsmp
		--with-gtk=3.0"

	# Use login shell by default (#12900)
	epatch "${FILESDIR}"/${PN}-2.22.0-default_shell.patch

	epatch "${FILESDIR}"/${PN}-2.33.4-fix-gdk-targets.patch

	[[ ${PV} != 9999 ]] && eautoreconf

	gnome2_src_prepare
}
