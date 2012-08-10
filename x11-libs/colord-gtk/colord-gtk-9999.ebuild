# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/colord-gtk/colord-gtk-0.1.22.ebuild,v 1.1 2012/08/10 19:03:00 tetromino Exp $

EAPI="4"

inherit autotools eutils
if [[ ${PV} = 9999 ]]; then
	GCONF_DEBUG="no"
	inherit gnome2-live # need all the hacks from gnome2-live_src_prepare
fi

DESCRIPTION="GTK support library for colord"
HOMEPAGE="http://www.freedesktop.org/software/colord/"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://gitorious.org/colord/colord-gtk.git"
else
	SRC_URI="http://www.freedesktop.org/software/colord/releases/${P}.tar.xz"
fi

LICENSE="LGPL-3"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd"
fi
IUSE="doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

COMMON_DEPEND=">=dev-libs/glib-2.28:2
	>=media-libs/lcms-2.2:2
	x11-libs/gdk-pixbuf:2[introspection?]
	x11-libs/gtk+:3[X(+),introspection?]
	x11-misc/colord[introspection?,vala?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.8 )"
# ${PN} was part of x11-misc/colord until 0.1.22
RDEPEND="${COMMON_DEPEND}
	!<x11-misc/colord-0.1.22"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9
	)
	vala? ( dev-lang/vala:0.14[vapigen] )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.1.22-automagic-vala.patch"
	if [[ ${PV} = 9999 ]]; then
		gnome2_src_prepare
	else
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable vala) \
		VAPIGEN=$(type -P vapigen-0.14)
}

src_install() {
	default
	prune_libtool_files
}
