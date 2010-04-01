# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools gnome2 eutils

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc introspection startup-notification"

RDEPEND=">=x11-libs/gtk+-2.19.7
	>=dev-libs/glib-2.16.0
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	startup-notification? ( >=x11-libs/startup-notification-0.4 )
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	dev-util/gtk-doc-am
	gnome-base/gnome-common
	doc? ( >=dev-util/gtk-doc-1.9 )
	x86-interix? (
		sys-libs/itx-bind
	)"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable startup-notification)
		$(use_enable introspection)"
}

src_prepare() {
	gnome2_src_prepare

	if use x86-interix; then
		# activate the itx-bind package...
		append-flags "-I${EPREFIX}/usr/include/bind"
		append-ldflags "-L${EPREFIX}/usr/lib/bind"
	fi
	
	if has_version '<sys-devel/libtool-2.2.6b'; then
	intltoolize --force --copy --automake || die "intltoolize failed"

	# Make it libtool-1 compatible, bug #280876
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"

	AT_M4DIR="m4" eautoreconf
	fi
}
