# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/metacity/metacity-2.20.0.ebuild,v 1.1 2007/10/05 05:39:56 leio Exp $

inherit eutils gnome2

DESCRIPTION="Gnome default windowmanager"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug xinerama"

RDEPEND=">=x11-libs/gtk+-2.10
		 >=x11-libs/pango-1.2
		 >=gnome-base/gconf-2
		 >=dev-libs/glib-2.6
		 >=x11-libs/libXcomposite-0.2
		 x11-libs/libXcursor
		 >=x11-libs/startup-notification-0.7
		 !x11-misc/expocity"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/pkgconfig-0.9
		>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog HACKING NEWS README *.txt doc/*.txt"

pkg_setup() {
	G2CONF="$(use_enable debug) $(use_enable xinerama)"
}
