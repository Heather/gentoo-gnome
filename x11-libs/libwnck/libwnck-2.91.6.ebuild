# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-2.30.6.ebuild,v 1.6 2011/01/30 19:15:57 armin76 Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2.90"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="doc +introspection startup-notification"

RDEPEND=">=x11-libs/gtk+-2.91.5:3[introspection?]
	>=dev-libs/glib-2.16:2
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	introspection? ( >=dev-libs/gobject-introspection-0.6.14 )
	startup-notification? ( >=x11-libs/startup-notification-0.4 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	doc? ( >=dev-util/gtk-doc-1.9 )
	x86-interix? ( sys-libs/itx-bind )"
# eautoreconf needs
#	dev-util/gtk-doc-am
#	gnome-base/gnome-common

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)
		$(use_enable startup-notification)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
}

src_prepare() {
	gnome2_src_prepare

	if use x86-interix; then
		# activate the itx-bind package...
		append-flags "-I${EPREFIX}/usr/include/bind"
		append-ldflags "-L${EPREFIX}/usr/lib/bind"
	fi
}
