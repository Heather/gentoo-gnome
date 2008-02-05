# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome.org

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://www.gnome.org/projects/totem/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hal"

RDEPEND=">=dev-libs/glib-2.13.4
		 >=x11-libs/gtk+-2.12
		 >=gnome-base/gnome-vfs-2.16
		 >=gnome-extra/evolution-data-server-1.12
		 hal? ( =sys-apps/hal-0.5* >=sys-apps/dbus-1.0 )"
DEPEND="${RDEPEND}
		!<media-video/totem-2.21
		>=dev-util/intltool-0.35"

src_compile() {
	econf $(use_enable hal) || die "configure failed"
	emake || die "build failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
