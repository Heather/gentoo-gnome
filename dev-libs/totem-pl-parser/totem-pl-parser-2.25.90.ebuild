# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/totem-pl-parser/totem-pl-parser-2.24.3.ebuild,v 1.1 2008/12/21 15:52:20 eva Exp $

inherit gnome.org

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://www.gnome.org/projects/totem/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc hal"

RDEPEND=">=dev-libs/glib-2.17.3
	>=x11-libs/gtk+-2.12
	>=gnome-extra/evolution-data-server-1.12"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	>=dev-util/intltool-0.35
	doc? ( dev-util/gtk-doc )"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
