# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gnome-nettool/gnome-nettool-2.20.0.ebuild,v 1.8 2008/01/10 09:12:06 vapier Exp $

inherit gnome2 eutils

DESCRIPTION="Collection of network tools"
HOMEPAGE="http://www.gnome.org/projects/gnome-network/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug"

COMMON_DEPEND=">=x11-libs/gtk+-2.5.4
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2"
RDEPEND="${COMMON_DEPEND}
	net-analyzer/traceroute
	app-admin/gnome-system-tools
	net-dns/bind-tools
	userland_GNU? ( net-misc/netkit-fingerd net-misc/whois )
	userland_BSD? ( net-misc/bsdwhois )"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	  app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable debug)"
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}"/${PN}-2.18.0-fbsd.patch
}
