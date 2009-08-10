# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Gobject-Introspection file Repository"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="atk avahi babl dbus gconf gnome-keyring gstreamer +gtk gtksourceview gupnp
libnotify libsoup libunique libwnck pango poppler vte webkit"

RDEPEND=">=dev-libs/gobject-introspection-0.6.3"
DEPEND="${RDEPEND}
	atk? ( >=dev-libs/atk-1.12.0 )
	avahi? ( >=net-dns/avahi-0.6 )
	babl? ( media-libs/babl )
	dbus? ( dev-libs/dbus-glib )
	gconf? ( gnome-base/gconf )
	gnome-keyring? ( gnome-base/gnome-keyring )
	goocanvas? ( x11-libs/goocanvas )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10 )
	gtk? (
		>=dev-libs/atk-1.12.0
		x11-libs/gtk+:2 )
	gtksourceview? ( x11-libs/gtksourceview )
	gupnp? (
		net-libs/gssdp
		net-libs/gupnp )
	libnotify? ( x11-libs/libnotify )
	libsoup? ( net-libs/libsoup:2.4 )
	libunique? ( >=dev-libs/libunique-1.0.0 )
	libwnck? ( x11-libs/libwnck )
	nautilus? ( gnome-base/nautilus )
	pango? ( x11-libs/pango )
	poppler? ( >=virtual/poppler-glib-0.8 )
	vte? ( x11-libs/vte )
	webkit? ( >=net-libs/webkit-gtk-1.0 )
"

pkg_setup() {
	# FIXME: installs even disabled stuff if it's a dependency of something enabled
	# XXX: Seemingly unrelated enabling is for Makefile-level dependencies
	# FIXME: Above mentioned dependencies are incomplete
	G2CONF="${G2CONF}
		--disable-clutter
		--disable-clutter-gtk
		--disable-clutter-cairo
		--disable-gnio
		$(use_enable atk)
		$(use_enable avahi)
		$(use_enable babl)
		$(use_enable dbus)
		$(use_enable gconf)
		$(use_enable gnome-keyring gnomekeyring)
		$(use_enable goocanvas)
		$(use_enable gstreamer)
		$(use_enable gtk)
		$(use_enable gtk atk)
		$(use_enable gtksourceview)
		$(use_enable gupnp gssdp)
		$(use_enable libnotify notify)
		$(use_enable libsoup soup)
		$(use_enable libunique unique)
		$(use_enable libwnck wnck)
		$(use_enable nautilus)
		$(use_enable pango)
		$(use_enable poppler)
		$(use_enable vte)
		$(use_enable webkit)
		$(use_enable webkit soup)
	"
}

src_prepare() {
	gnome2_src_prepare

	epatch "${FILESDIR}/${P}-fix-worlds-worst-automagic-configure.patch"

	eautoreconf
}
