# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/swfdec-gnome/swfdec-gnome-2.22.2.ebuild,v 1.5 2008/06/02 10:41:13 aballier Exp $

inherit gnome2 eutils autotools

DESCRIPTION="flash player and thumbnailer for GNOME"
HOMEPAGE="http://swfdec.freedesktop.org/wiki/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12.0
		gnome-base/gconf
		>=media-libs/swfdec-0.7.4"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext"

DOCS="NEWS"

pkg_setup() {
	if ! built_with_use media-libs/swfdec gtk ; then
		einfo "You must build swfdec with the gtk USE flag to build"
		einfo "swfdec-gtk, which is required by ${PN}"
		die "Please re-emerge media-libs/swfdec with the gtk USE flag"
	fi
}
