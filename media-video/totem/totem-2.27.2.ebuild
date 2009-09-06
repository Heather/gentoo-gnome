# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-2.26.3.ebuild,v 1.2 2009/07/18 19:17:31 armin76 Exp $

EAPI="2"

inherit autotools eutils gnome2 multilib python

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://gnome.org/projects/totem/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="bluetooth debug doc galago iplayer lirc nautilus nsplugin python tracker +youtube"

# TODO:
# easy-publish-and-consume is not in tree (epc)
# Cone (VLC) plugin needs someone with the right setup (remi ?)
# check gmyth requirement ? -> waiting for updates in tree
# coherence plugin not enabled until we have deps in tree
RDEPEND=">=dev-libs/glib-2.15
	>=x11-libs/gtk+-2.16.0
	>=gnome-base/gconf-2.0
	>=dev-libs/totem-pl-parser-2.27.0
	>=x11-themes/gnome-icon-theme-2.16
	x11-libs/cairo
	app-text/iso-codes
	>=dev-libs/libxml2-2.6
	>=dev-libs/dbus-glib-0.71
	>=media-libs/gstreamer-0.10.23.2
	>=media-libs/gst-plugins-good-0.10
	>=media-libs/gst-plugins-base-0.10.23.2
	>=media-plugins/gst-plugins-gconf-0.10

	>=media-plugins/gst-plugins-taglib-0.10
	>=media-plugins/gst-plugins-gio-0.10
	>=media-plugins/gst-plugins-pango-0.10
	>=media-plugins/gst-plugins-x-0.10
	>=media-plugins/gst-plugins-meta-0.10-r2

	dev-libs/libunique
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	>=x11-libs/libXrandr-1.1.1
	>=x11-libs/libXxf86vm-1.0.1

	bluetooth? ( || (
		net-wireless/bluez
		net-wireless/bluez-libs ) )
	galago? ( >=dev-libs/libgalago-0.5.2 )
	iplayer? (
		dev-python/pygobject
		dev-python/pygtk
		dev-python/httplib2
		dev-python/feedparser
		dev-python/beautifulsoup )
	lirc? ( app-misc/lirc )
	nautilus? ( >=gnome-base/nautilus-2.10 )
	python? (
		dev-lang/python[threads]
		>=dev-python/pygtk-2.12
		dev-python/pyxdg
		dev-python/gst-python
		dev-python/dbus-python
		dev-python/gconf-python )
	tracker? (
		>=app-misc/tracker-0.6
		<app-misc/tracker-0.7 )
	youtube? (
		>=dev-libs/libgdata-0.4.0
		media-plugins/gst-plugins-soup )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto
	app-text/scrollkeeper
	gnome-base/gnome-common
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.20
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.11 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

# FIXME: tests broken with USE="-doc" upstream bug #577774
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-schemas-install
		--disable-static
		--disable-vala
		--with-dbus
		--with-smclient
		--enable-easy-codec-installation
		$(use_enable nsplugin browser-plugins)"

	# Plugin configuration
	G2CONF="${G2CONF}
		BROWSER_PLUGIN_DIR=/usr/$(get_libdir)/nsbrowser/plugins
		PLUGINDIR=/usr/$(get_libdir)/totem/plugins"

	local plugins="properties,thumbnail,screensaver,ontop,gromit,media-player-keys,skipto,brasero-disc-recorder,screenshot"
	use bluetooth && plugins="${plugins},bemused"
	use galago && plugins="${plugins},galago"
	use iplayer && plugins="${plugins},iplayer"
	use lirc && plugins="${plugins},lirc"
	use python && plugins="${plugins},opensubtitles,jamendo,pythonconsole,dbus-service"
	use tracker && plugins="${plugins},tracker"
	use youtube && plugins="${plugins},youtube"

	G2CONF="${G2CONF} --with-plugins=${plugins}"

	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable nautilus)
		$(use_enable python)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix broken smclient option passing
	epatch "${FILESDIR}/${PN}-2.26.1-smclient-target-detection.patch"

	# FIXME: tarball generated with broken gtk-doc, revisit me.
	if use doc; then
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=/usr/bin/gtkdoc-rebase" \
			-i gtk-doc.make || die "sed 1 failed"
	else
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=$(type -P true)" \
			-i gtk-doc.make || die "sed 2 failed"
	fi

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_configure() {
	# FIXME: why does it need write access here, probably need to set up a fake
	# home in /var/tmp like other pkgs do

	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	addpredict "$(unset HOME; echo ~)/.gnome2"

	gnome2_src_configure
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
	python_mod_cleanup /usr/$(get_libdir)/totem/plugins
}
