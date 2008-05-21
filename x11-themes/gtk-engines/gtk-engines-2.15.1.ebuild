# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines/gtk-engines-2.14.1.ebuild,v 1.1 2008/04/09 21:20:02 eva Exp $

inherit gnome2

DESCRIPTION="GTK+2 standard engines and themes"
HOMEPAGE="http://www.gtk.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="accessibility static"

RDEPEND=">=x11-libs/gtk+-2.12"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.31
		>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="$(use_enable static) --enable-animation --enable-lua --disable-deprecated"
	use accessibility || G2CONF="${G2CONF} --disable-hc"
}
