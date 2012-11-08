# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # plugins are dlopened

PYTHON_DEPEND="python? 2:2.5"
PYTHON_USE_WITH="threads"
PYTHON_USE_WITH_OPT="python"

inherit gnome2 multilib python
if [[ ${PV} = 9999 ]]; then
	VALA_MIN_API_VERSION="0.14"
	inherit gnome2-live vala
fi

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://projects.gnome.org/totem/"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="doc flash grilo +introspection lirc nautilus nsplugin +python test zeitgeist"
# see bug #359379
REQUIRED_USE="flash? ( nsplugin )
	python? ( introspection )
	zeitgeist? ( introspection )"

if [[ ${PV} = 9999 ]]; then
	IUSE+=" vala"
	REQUIRED_USE+=" zeitgeist? ( vala )"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86 ~x86-fbsd"
fi

# TODO:
# Cone (VLC) plugin needs someone with the right setup (remi ?)
# coherence plugin broken upstream
#
# FIXME: Automagic tracker-0.9.0
# Runtime dependency on gnome-session-2.91
# FIXME: does not exist yet:	media-plugins/gst-plugins-meta:1.0
RDEPEND="
	>=dev-libs/glib-2.33:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.5.2:3[introspection?]
	>=dev-libs/totem-pl-parser-2.32.4[introspection?]
	>=dev-libs/libpeas-1.1.0[gtk]
	>=x11-themes/gnome-icon-theme-2.16
	x11-libs/cairo
	>=dev-libs/libxml2-2.6:2
	>=media-libs/clutter-1.6.8:1.0
	>=media-libs/clutter-gst-1.5.5:2.0
	>=media-libs/clutter-gtk-1.0.2:1.0
	x11-libs/mx:1.0

	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[X,introspection?,pango]
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-taglib:1.0

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXxf86vm-1.0.1

	gnome-base/gsettings-desktop-schemas
	x11-themes/gnome-icon-theme-symbolic

	flash? ( dev-libs/totem-pl-parser[quvi] )
	grilo? ( media-libs/grilo:0.2 )
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
		dev-python/dbus-python )
	zeitgeist? ( dev-libs/libzeitgeist )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	>=app-text/gnome-doc-utils-0.20.3
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	>=dev-util/gtk-doc-am-1.14
	sys-devel/gettext
	x11-proto/xextproto
	x11-proto/xproto
	virtual/pkgconfig
	test? ( python? ( dev-python/pylint ) )
"
# docbook-xml-dtd is needed for user do
# Only needed when regenerating C sources from Vala files
[[ ${PV} = 9999 ]] && DEPEND+=" vala? ( $(vala_depend) )"

# XXX: pylint checks fail because of bad code
RESTRICT="test"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# AC_CONFIG_AUX_DIR_DEFAULT doesn't exist, and eautoreconf/aclocal fails
	mkdir -p m4

	#if [[ ${PV} != 9999 ]]; then
	#	intltoolize --force --copy --automake || die "intltoolize failed"
	#	eautoreconf
	#fi

	use python && python_clean_py-compile_files
	if [[ ${PV} = 9999 ]]; then
		# Only needed when regenerating C sources from Vala files
		use vala && vala_src_prepare
	fi
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	use nsplugin && DOCS="${DOCS} browser-plugin/README.browser-plugin"
	G2CONF="${G2CONF}
		--disable-run-in-source-tree
		--disable-schemas-compile
		--disable-static
		--with-smclient=auto
		--enable-easy-codec-installation
		$(use_enable flash vegas-plugin)
		$(use_enable introspection)
		$(use_enable nautilus)
		$(use_enable nsplugin browser-plugins)
		$(use_enable python)
		BROWSER_PLUGIN_DIR=/usr/$(get_libdir)/nsbrowser/plugins"

	if ! use test; then
		# pylint is checked unconditionally, but is only used for make check
		G2CONF="${G2CONF} PYLINT=$(type -P true)"
	fi
	#--with-smclient=auto needed to correctly link to libICE and libSM

	# Disabled: sample-python, sample-vala
	# apple-trailers, autoload-subtitles, recent
	local plugins="apple-trailers,autoload-subtitles,brasero-disc-recorder"
	plugins+=",chapters,im-status,gromit,media-player-keys,ontop"
	plugins+=",properties,recent,screensaver,screenshot,sidebar-test"
	plugins+=",skipto"
	use grilo && plugins+=",grilo"
	use lirc && plugins+=",lirc"
	use nautilus && plugins+=",save-file"
	use python && plugins+=",dbusservice,pythonconsole,opensubtitles"
	if [[ ${PV} = 9999 ]]; then
		# Only needed when regenerating C sources from Vala files
		G2CONF="${G2CONF} $(use_enable vala)"
		use vala && plugins+=",rotation"
	else
		G2CONF="${G2CONF} --enable-vala VALAC=$(type -P true)"
		plugins+=",rotation"
	fi
	use zeitgeist && plugins+=",zeitgeist-dp"

	G2CONF="${G2CONF} --with-plugins=${plugins}"

	# Work around sandbox violations when FEATURES=-userpriv caused by
	# gst-inspect-0.10 (bug #358755)
	unset DISPLAY
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
	use python && python_mod_cleanup /usr/$(get_libdir)/totem/plugins
}
