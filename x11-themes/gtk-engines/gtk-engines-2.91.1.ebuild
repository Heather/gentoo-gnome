# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines/gtk-engines-2.20.1-r1.ebuild,v 1.1 2010/06/13 16:16:22 pacho Exp $

EAPI="2"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="GTK+3 standard engines and themes"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="accessibility"

RDEPEND=">=x11-libs/gtk+-2.91:3"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.31
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --enable-animation $(use_enable accessibility hc)"
}
