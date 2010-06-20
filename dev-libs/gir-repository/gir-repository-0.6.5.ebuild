# Copyright 1999-2010 Gentoo Foundation
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
IUSE="avahi babl dbus gconf gnome-keyring goocanvas gtksourceview libnotify
libwnck nautilus poppler vte"

RDEPEND=">=dev-libs/gobject-introspection-0.6.5"
DEPEND="${RDEPEND}
	avahi? ( >=net-dns/avahi-0.6 )
	babl? ( media-libs/babl )
	dbus? ( dev-libs/dbus-glib )
	gconf? ( gnome-base/gconf )
	gnome-keyring? ( gnome-base/gnome-keyring )
	goocanvas? ( x11-libs/goocanvas )
	gtksourceview? ( x11-libs/gtksourceview )
	libnotify? ( x11-libs/libnotify )
	libsoup? ( net-libs/libsoup:2.4 )
	libwnck? ( x11-libs/libwnck )
	nautilus? ( gnome-base/nautilus )
	poppler? ( >=app-text/poppler-0.8[cairo] )
	vte? ( x11-libs/vte )
"

pkg_setup() {
	# FIXME: installs even disabled stuff if it's a dependency of something enabled
	G2CONF="${G2CONF}
		--disable-atk
		--disable-clutter
		--disable-clutter-gtk
		--disable-clutter-cairo
		--disable-gmenu
		--disable-gnio
		--disable-gstreamer
		--disable-gtk
		--disable-gssdp
		--disable-pango
		--disable-soup
		--disable-webkit
		--disable-unique
		$(use_enable avahi)
		$(use_enable babl)
		$(use_enable dbus)
		$(use_enable gconf)
		$(use_enable gnome-keyring gnomekeyring)
		$(use_enable goocanvas)
		$(use_enable gtksourceview)
		$(use_enable libnotify notify)
		$(use_enable libwnck wnck)
		$(use_enable nautilus)
		$(use_enable poppler)
		$(use_enable vte)
	"

	# XXX: Auto-enabling is for Makefile-level dependencies
	# FIXME: these dependencies are probably incomplete
	if use goocanvas || use gtksourceview || use libnotify || use libwnck \
		|| use nautilus || use poppler || use vte; then
		G2CONF="${G2CONF} --enable-atk --enable-pango --enable-gtk"
	fi
}

src_prepare() {
	gnome2_src_prepare

	epatch "${FILESDIR}/${P}-fix-worlds-worst-automagic-configure.patch"

	eautoreconf
}

src_install() {
	gnome2_src_install
	
	# These are needed to build other .girs and .typelibs,
	# but they shouldn't be installed since they are provided by gtk+/atk/pango
	for i in Pango{,FT2,Cairo,Xft,X}-1.0 Atk-1.0 Gtk-2.0 Gdk{,Pixbuf}-2.0; do
		rm -f "${D}/usr/lib64/girepository-1.0/${i}.typelib"
		rm -f "${D}/usr/lib/girepository-1.0/${i}.typelib"
		rm -f "${D}/usr/share/gir-1.0/${i}.gir"
	done
	rm -f ${D}/usr/lib/{,debug/usr/lib/}*{Gdk,Gtk}*
}
