# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-2.26.2-r2.ebuild,v 1.2 2009/08/09 20:44:52 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools gnome2 eutils

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc startup-notification"

RDEPEND=">=x11-libs/gtk+-2.16.0
	>=dev-libs/glib-2.16.0
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	startup-notification? ( >=x11-libs/startup-notification-0.4 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	dev-util/gtk-doc-am
	gnome-base/gnome-common
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable startup-notification)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix automagic startup-notification, bug #278464
	epatch "${FILESDIR}"/${PN}-2.26.2-automagic.patch

	# Fix glib-mkenum auto generation (bug #279832)
	epatch "${FILESDIR}"/${PN}-2.26.2-fix-glib-mkenums.diff
	# required to force regeneration of wnck-enum-types.h
	rm libwnck/wnck-enum-types.h

	intltoolize --force --copy --automake || die "intltoolize failed"

	# Make it libtool-1 compatible, bug #280876
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"

	AT_M4DIR="m4" eautoreconf
}
