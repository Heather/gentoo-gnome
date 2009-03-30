# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-2.24.3-r1.ebuild,v 1.1 2009/01/18 22:51:46 eva Exp $
EAPI=2

inherit eutils gnome2 multilib python

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://gnome.org/projects/totem/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="bluetooth debug galago mythtv lirc nautilus nsplugin python tracker"

# TODO:
# easy-publish-and-consume is not in tree (epc)
# Cone (VLC) plugin needs someone with the right setup (remi ?)
# youtube plugins requires gst-plugins-soup

RDEPEND=">=dev-libs/glib-2.15
	>=x11-libs/gtk+-2.13.0
	>=gnome-base/gconf-2.0
	>=dev-libs/totem-pl-parser-2.23.91
	>=x11-themes/gnome-icon-theme-2.16
	x11-libs/cairo
	app-text/iso-codes
	dev-libs/libxml2
	>=dev-libs/dbus-glib-0.71
	>=media-libs/gstreamer-0.10.16
	>=media-libs/gst-plugins-good-0.10
	>=media-libs/gst-plugins-base-0.10.12
	>=media-plugins/gst-plugins-pango-0.10
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-gio-0.10

	>=media-plugins/gst-plugins-x-0.10
	>=media-plugins/gst-plugins-meta-0.10-r2

	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	>=x11-libs/libXrandr-1.1.1
	>=x11-libs/libXxf86vm-1.0.1

	bluetooth? ( || (
		net-wireless/bluez
		net-wireless/bluez-libs ) )
	galago? ( >=dev-libs/libgalago-0.5.2 )
	mythtv? (
		>=media-libs/gmyth-0.7.1
		>=media-libs/gmyth-upnp-0.7.1 )
	lirc? ( app-misc/lirc )
	nautilus? ( >=gnome-base/nautilus-2.10 )
	python? (
		dev-lang/python[threads]
		>=dev-python/pygtk-2.12
		dev-python/pyxdg
		dev-python/gdata )
	tracker? (
		>=app-misc/tracker-0.5.3
		>=gnome-base/libgnomeui-2 )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto
	app-text/scrollkeeper
	gnome-base/gnome-common
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.20"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-schemas-install
		--disable-vala
		--with-dbus
		--enable-easy-codec-installation
		$(use_enable nsplugin browser-plugins)"

	# Plugin configuration
	G2CONF="${G2CONF}
		BROWSER_PLUGIN_DIR=/usr/$(get_libdir)/nsbrowser/plugins
	    PLUGINDIR=/usr/$(get_libdir)/totem/plugins"

	local plugins="properties,thumbnail,screensaver,ontop,gromit,media-player-keys,skipto,brasero-disc-recorder"
	use bluetooth && plugins="${plugins},bemused"
	use galago && plugins="${plugins},galago"
	use mythtv && plugins="${plugins},mythtv"
	use lirc && plugins="${plugins},lirc"

	# Test again before pushing to the tree.
	use python && plugins="${plugins},youtube,opensubtitles"
	use python && plugins="${plugins},pythonconsole"

	use tracker && plugins="${plugins},tracker"

	G2CONF="${G2CONF} --with-plugins=${plugins}"

	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable nautilus)
		$(use_enable python)"
}

src_prepare() {
	gnome2_src_prepare

	# http://svn.gnome.org/viewvc/totem?view=revision&revision=6177
	epatch "${FILESDIR}/${P}-upstream-brown-bag-revert-opensubtitles.patch"

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_compile() {
	# FIXME: why does it need write access here, probably need to set up a fake
	# home in /var/tmp like other pkgs do

	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	addpredict "$(unset HOME; echo ~)/.gnome2"

	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_need_rebuild
		python_mod_optimize /usr/$(get_libdir)/totem/plugins
	fi

	ewarn
	ewarn "If totem doesn't play some video format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	gnome2_pkg_postrm
	use python && python_mod_cleanup /usr/$(get_libdir)/totem/plugins
}
