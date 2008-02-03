# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/evince-2.20.2.ebuild,v 1.4 2008/02/01 18:47:28 ranger Exp $

WANT_AUTOMAKE="1.9"
inherit eutils gnome2 autotools

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="dbus djvu doc dvi gnome t1lib tiff"

RDEPEND="
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	>=x11-libs/gtk+-2.10
	gnome-base/gnome-keyring
	>=gnome-base/libgnomeui-2.14
	>=gnome-base/libgnome-2.14
	dev-libs/libxml2
	>=x11-themes/gnome-icon-theme-2.17.1
	>=gnome-base/gnome-vfs-2.0
	>=gnome-base/libglade-2
	>=dev-libs/glib-2
	gnome? ( >=gnome-base/nautilus-2.10 )
	>=app-text/poppler-bindings-0.6
	dvi? (
		virtual/tetex
		t1lib? ( >=media-libs/t1lib-5.0.0 )
	)
	tiff? ( >=media-libs/tiff-3.6 )
	>=gnome-base/gconf-2
	djvu? ( >=app-text/djvu-3.5.17 )
	>=app-text/libspectre-0.2.0"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=sys-devel/automake-1.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README TODO"
ELTCONF="--portage"
RESTRICT="test"

pkg_setup() {
	G2CONF="--disable-scrollkeeper \
		--enable-comics		\
		--enable-impress	\
		$(use_enable dbus)  \
		$(use_enable djvu)  \
		$(use_enable dvi)   \
		$(use_enable t1lib) \
		$(use_enable tiff)  \
		$(use_enable gnome nautilus)"

	if ! built_with_use app-text/poppler-bindings gtk; then
		einfo "Please re-emerge app-text/poppler-bindings with the gtk USE flag set"
		die "poppler-bindings needs gtk flag set"
	fi
}

src_unpack() {
	gnome2_src_unpack

	# Fix .desktop file so menu item shows up
	epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch

	# Make dbus actually switchable
	epatch "${FILESDIR}"/${PN}-0.6.1-dbus-switch.patch

	cp aclocal.m4 old_macros.m4
	AT_M4DIR="." eautoreconf
}
