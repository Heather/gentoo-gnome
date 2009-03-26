# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/evince-2.24.2.ebuild,v 1.1 2008/11/24 20:57:12 eva Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dbus debug djvu doc dvi gnome-keyring nautilus t1lib tiff"

# FIXME: enable gobject-introspection when we have an ebuild for it.
RDEPEND="
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	>=x11-libs/gtk+-2.12
	>=dev-libs/glib-2.18.0
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.22.0 )
	>=x11-themes/gnome-icon-theme-2.17.1
	>=dev-libs/libxml2-2.5
	x11-libs/libSM
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	nautilus? ( >=gnome-base/nautilus-2.10 )
	>=app-text/poppler-bindings-0.8[gtk,cairo]
	dvi? (
		virtual/tex-base
		t1lib? ( >=media-libs/t1lib-5.0.0 )
	)
	tiff? ( >=media-libs/tiff-3.6 )
	djvu? ( >=app-text/djvu-3.5.17 )
	>=app-text/libspectre-0.2.0"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.1.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"
ELTCONF="--portage"
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--enable-pdf
		--enable-comics
		--enable-impress
		--enable-thumbnailer
		--with-gconf
		$(use_enable dbus)
		$(use_enable djvu)
		$(use_enable dvi)
		$(use_with gnome-keyring keyring)
		$(use_enable t1lib)
		$(use_enable tiff)
		$(use_enable nautilus)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix .desktop file so menu item shows up
	epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch
}
