# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-2.22.2-r1.ebuild,v 1.1 2008/05/09 17:09:33 remi Exp $

inherit eutils gnome2 multilib python

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://gnome.org/projects/totem/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~sparc ~x86"

IUSE="bluetooth debug galago gnome lirc nautilus nsplugin nvtv python tracker"

RDEPEND=">=dev-libs/glib-2.15
		 >=x11-libs/gtk+-2.13.0
		 >=gnome-base/gconf-2.0
		 >=dev-libs/totem-pl-parser-2.23.91
		 >=x11-themes/gnome-icon-theme-2.16
		   app-text/iso-codes
		   dev-libs/libxml2
		 >=dev-libs/dbus-glib-0.71
		 >=media-libs/gstreamer-0.10.16
		 >=media-libs/gst-plugins-good-0.10
		 >=media-libs/gst-plugins-base-0.10.12
		 >=media-plugins/gst-plugins-pango-0.10
		 >=media-plugins/gst-plugins-gconf-0.10
		 >=media-plugins/gst-plugins-gnomevfs-0.10

		 >=media-plugins/gst-plugins-x-0.10
		 >=media-plugins/gst-plugins-meta-0.10-r2

		 x11-libs/libX11
		 x11-libs/libXtst
		 >=x11-libs/libXrandr-1.1.1
		 >=x11-libs/libXxf86vm-1.0.1

		 bluetooth? ( net-wireless/bluez-libs )
		 galago? ( >=dev-libs/libgalago-0.5.2 )
		 gnome? (
					>=gnome-base/libgnome-2.14
					>=gnome-base/libgnomeui-2.4
				)
		 lirc? ( app-misc/lirc )
		 nautilus? ( >=gnome-base/nautilus-2.10 )
		 nsplugin?	(
						|| (
							net-libs/xulrunner
							www-client/seamonkey
							www-client/mozilla-firefox )
						>=x11-misc/shared-mime-info-0.22
						>=x11-libs/startup-notification-0.8
					)
		 nvtv? ( >=media-tv/nvtv-0.4.5 )
		 python? ( >=dev-python/pygtk-2.12 >=dev-python/gdata-1 )
		 tracker? ( >=app-misc/tracker-0.5.3 >=gnome-base/libgnomeui-2 )"
DEPEND="${RDEPEND}
		  app-text/scrollkeeper
		  gnome-base/gnome-common
		  app-text/gnome-doc-utils
		>=dev-util/intltool-0.40
		>=dev-util/pkgconfig-0.20"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	if use python ; then
		if ! built_with_use --missing false dev-lang/python threads ; then
			if built_with_use --missing true dev-lang/python nothreads ; then
				elog "totem's python support requires that python be built with threading support"
				elog "Please rebuild python with threading support and then build totem again."
				eerror "python built without threading support"
			fi
		fi
	fi

	G2CONF="${G2CONF}
		--disable-vala
		--with-dbus
		--enable-easy-codec-installation
		$(use_enable nsplugin browser-plugins)"

	# plugins configuration
	G2CONF="${G2CONF}
		BROWSER_PLUGIN_DIR=/usr/$(get_libdir)/nsbrowser/plugins
	    PLUGINDIR=/usr/$(get_libdir)/totem/plugins"

	local plugins="properties,thumbnail,screensaver,ontop,gromit,media-player-keys,skipto"
	use bluetooth && plugins="${plugins},bemused"
	use galago && plugins="${plugins},galago"
	use lirc && plugins="${plugins},lirc"

	# Test again before pushing to the tree.
	use python && plugins="${plugins},youtube"

	use tracker && plugins="${plugins},tracker"

	G2CONF="${G2CONF} --with-plugins=${plugins}"

	G2CONF="${G2CONF}
			$(use_enable debug)
			$(use_enable nautilus)
			$(use_enable nvtv)
			$(use_enable python)"
}

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_compile() {
	# FIXME: why does it need write access here, probably need to set up a fake
	# home in /var/tmp like other pkgs do

	#addpredict "/root/.gconfd"
	#addpredict "/root/.gconf"
	addpredict "/root/.gnome2"

	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	use python && python_mod_optimize /usr/$(get_libdir)/totem/plugins

	ewarn
	ewarn "If totem doesn't play some video format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	use python && python_mod_cleanup /usr/$(get_libdir)/totem/plugins
}
