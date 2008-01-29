# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeui/libgnomeui-2.20.1.1.ebuild,v 1.7 2007/11/29 05:18:07 jer Exp $

inherit eutils gnome2

DESCRIPTION="User Interface routines for Gnome"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="doc jpeg"

RDEPEND=">=dev-libs/libxml2-2.4.20
	>=gnome-base/libgnome-2.13.7
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/libbonoboui-2.13.1
	>=gnome-base/gconf-2
	>=x11-libs/pango-1.1.2
	>=dev-libs/glib-2.15.2
	>=x11-libs/gtk+-2.11.5
	>=gnome-base/gnome-vfs-2.7.3
	>=gnome-base/libglade-2
	>=gnome-base/gnome-keyring-0.4
	>=dev-libs/popt-1.5
	jpeg? ( media-libs/jpeg )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1 )"

PDEPEND="x11-themes/gnome-icon-theme"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="$(use_with jpeg libjpeg)"
}

src_unpack() {
	gnome2_src_unpack

	# Re-enable deprecated gnome druid code
	epatch "${FILESDIR}"/${PN}-2.19.1-enable-druid.patch
}
