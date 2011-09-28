# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-2.30.0-r1.ebuild,v 1.1 2010/06/13 20:36:55 pacho Exp $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # plugins are dlopened
WANT_AUTOMAKE="1.11"
PYTHON_DEPEND="python? 2:2.4"
PYTHON_USE_WITH="threads"
PYTHON_USE_WITH_OPT="python"

inherit gnome2 multilib python
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://projects.gnome.org/totem/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="bluetooth doc grilo +introspection iplayer lirc nautilus nsplugin +python +youtube vala" # zeroconf

# TODO:
# Cone (VLC) plugin needs someone with the right setup (remi ?)
# coherence plugin broken upstream
#
# FIXME: Automagic tracker-0.9.0
# XXX: Add Zeitgeist support when it gets added to GNOME 3 (3.2?)
# Runtime dependency on gnome-session-2.91
RDEPEND=">=dev-libs/glib-2.27.92:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-2.99.3:3[introspection?]
	>=dev-libs/totem-pl-parser-2.32.4[introspection?]
	>=dev-libs/libpeas-1.1.0[gtk]
	>=x11-themes/gnome-icon-theme-2.16
	x11-libs/cairo
	>=dev-libs/libxml2-2.6:2
	>=media-libs/clutter-1.6.8:1.0
	>=media-libs/clutter-gst-1.3.9:1.0
	>=media-libs/clutter-gtk-1.0.2:1.0
	>=media-libs/gstreamer-0.10.30:0.10
	>=media-libs/gst-plugins-base-0.10.30:0.10
	x11-libs/mx:1.0

	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-taglib:0.10
	media-plugins/gst-plugins-gio:0.10
	media-plugins/gst-plugins-pango:0.10
	media-plugins/gst-plugins-x:0.10
	media-plugins/gst-plugins-meta:0.10

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	>=x11-libs/libXxf86vm-1.0.1

	bluetooth? ( net-wireless/bluez )
	grilo? ( >=media-libs/grilo-0.1.16 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	lirc? ( app-misc/lirc )
	nautilus? ( >=gnome-base/nautilus-2.91.3 )
	nsplugin? (
		>=dev-libs/dbus-glib-0.82
		>=x11-misc/shared-mime-info-0.22 )
	python? (
		>=dev-libs/gobject-introspection-0.6.7
		>=dev-python/pygobject-2.90.3:3
		>=x11-libs/gtk+-2.91.7:3[introspection]
		dev-python/pyxdg
		dev-python/gst-python:0.10
		dev-python/dbus-python
		iplayer? (
			dev-python/httplib2
			dev-python/feedparser
			dev-python/beautifulsoup ) )
	vala? ( >=dev-lang/vala-0.12.1:0.12 )
	youtube? (
		>=dev-libs/libgdata-0.7.0
		net-libs/libsoup:2.4
		media-plugins/gst-plugins-soup:0.10
		>=dev-libs/totem-pl-parser-2.32.4[quvi] )"
#	zeroconf? ( >=net-libs/libepc-0.5.0 )
# XXX: zeroconf requires unreleased version of libepc

DEPEND="${RDEPEND}
	sys-devel/gettext
	x11-proto/xproto
	x11-proto/xextproto
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.20.3
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.20
	app-text/docbook-xml-dtd:4.5
	gnome-base/gnome-common
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.14 )"
# docbook-xml-dtd is needed for user doc

pkg_setup() {
	# To remove when python eclass supports EAPI=4
	# see bug #359379
	if use python && ! use introspection; then
		eerror "USE=python requires USE=introspection"
		die "USE=python requires USE=introspection"
	fi

	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-run-in-source-tree
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static
		--with-smclient=auto
		--enable-easy-codec-installation
		$(use_enable introspection)
		$(use_enable nautilus)
		$(use_enable nsplugin browser-plugins)
		$(use_enable python)
		$(use_enable python introspection)
		$(use_enable vala)
		VALAC=$(type -P valac-0.12)
		BROWSER_PLUGIN_DIR=/usr/$(get_libdir)/nsbrowser/plugins"
	#--with-smclient=auto needed to correctly link to libICE and libSM

	# Disabled: sample-python, sample-vala, zeitgeist-dp
	local plugins="brasero-disc-recorder,chapters,im-status,gromit"
	plugins="${plugins},media-player-keys,ontop,properties,screensaver"
	plugins="${plugins},screenshot,sidebar-test,skipto"
	use bluetooth && plugins="${plugins},bemused"
	use grilo && plugins="${plugins},grilo"
	use iplayer && plugins="${plugins},iplayer"
	use lirc && plugins="${plugins},lirc"
	use nautilus && plugins="${plugins},save-file"
	use python && plugins="${plugins},dbusservice,pythonconsole,opensubtitles"
	use vala && plugins="${plugins},rotation"
	use youtube && plugins="${plugins},youtube"
	# XXX: zeroconf requires unreleased version of libepc
	# use zeroconf && plugins="${plugins},publish"

	G2CONF="${G2CONF} --with-plugins=${plugins}"

	python_set_active_version 2
}

src_prepare() {
	# AC_CONFIG_AUX_DIR_DEFAULT doesn't exist, and eautoreconf/aclocal fails
	mkdir -p m4

	#if [[ ${PV} != 9999 ]]; then
	#	intltoolize --force --copy --automake || die "intltoolize failed"
	#	eautoreconf
	#fi

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	gnome2_src_prepare
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
