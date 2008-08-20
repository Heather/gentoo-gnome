# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gdl/gdl-0.7.11.ebuild,v 1.3 2008/06/06 19:11:41 armin76 Exp $

inherit gnome2

DESCRIPTION="The Gnome Devtool Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gnome"

RDEPEND=">=dev-libs/glib-2
		 >=x11-libs/gtk+-2.12
		 >=dev-libs/libxml2-2.4
		 >=gnome-base/libglade-2.0
		 gnome? (
					>=gnome-base/libgnomeui-2.6
					>=gnome-base/gnome-vfs-2.6
					>=gnome-base/gconf-2
				)"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		>=dev-util/intltool-0.35
		doc? ( >=dev-utils/gtk-doc-1.4 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable gnome)"
}
