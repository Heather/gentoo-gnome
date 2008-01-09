# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-2.20.1.ebuild,v 1.2 2007/10/30 06:20:01 compnerd Exp $

inherit autotools eutils gnome2 multilib

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://gnome.org/projects/totem/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

# No 0.10.0 release for gst-plugins-pitdfdll yet
# IUSE="win32codecs"

IUSE="a52 alsa bluetooth debug dvd ffmpeg flac galago gnome hal lirc mad mpeg nsplugin nvtv ogg python seamonkey theora tracker vorbis xulrunner xv"

RDEPEND=">=dev-libs/glib-2.13.4
	 >=x11-libs/gtk+-2.12.1
	 >=gnome-base/gconf-2.0
	 >=gnome-base/libglade-2.0
	 >=gnome-base/gnome-vfs-2.16
	 >=dev-libs/totem-pl-parser-2.21.3
	 >=x11-themes/gnome-icon-theme-2.16
	 >=x11-libs/startup-notification-0.8
	   app-text/iso-codes
	   dev-libs/libxml2
	 >=dev-libs/dbus-glib-0.71
	 >=media-libs/gstreamer-0.10.12
	 >=media-libs/gst-plugins-good-0.10
	 >=media-libs/gst-plugins-base-0.10.12
	 >=media-plugins/gst-plugins-x-0.10
	 >=media-plugins/gst-plugins-pango-0.10
	 >=media-plugins/gst-plugins-gconf-0.10
	 >=media-plugins/gst-plugins-gnomevfs-0.10

	 x11-libs/libX11
	 x11-libs/libXtst
	 >=x11-libs/libXrandr-1.1.1
	 >=x11-libs/libXxf86vm-1.0.1

	 bluetooth? ( net-wireless/bluez-libs )
	 galago? ( >=dev-libs/libgalago-0.5.2 )
	 gnome? (
				>=gnome-base/libgnome-2.14
				>=gnome-base/libgnomeui-2.4
				>=gnome-base/gnome-desktop-2.2
				>=gnome-base/nautilus-2.10
	 			>=gnome-base/control-center-2.18
			)
	 hal? ( =sys-apps/hal-0.5* )
	 lirc? ( app-misc/lirc )
	 nsplugin?	(
	 			|| (
					xulrunner? ( net-libs/xulrunner )
					seamonkey? ( www-client/seamonkey )
					www-client/mozilla-firefox
				)
				>=x11-misc/shared-mime-info-0.22
				>=x11-libs/startup-notification-0.8
			)
	 python? ( >=dev-python/pygtk-2.8 >=dev-python/gdata-1  )
	 tracker? ( >=app-misc/tracker-0.5.3 )
	 nvtv? ( >=media-tv/nvtv-0.4.5 )

	 alsa? ( >=media-plugins/gst-plugins-alsa-0.10 )
	 a52? ( >=media-plugins/gst-plugins-a52dec-0.10 )
	 !sparc? ( dvd? (
						>=media-libs/gst-plugins-ugly-0.10
						>=media-plugins/gst-plugins-a52dec-0.10
						>=media-plugins/gst-plugins-dvdread-0.10
						>=media-plugins/gst-plugins-mpeg2dec-0.10
					)
			 )
	 !sparc? ( ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10 ) )
	 flac? ( >=media-plugins/gst-plugins-flac-0.10 )
	 mad? ( >=media-plugins/gst-plugins-mad-0.10 )
	 !sparc? ( mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-0.10 ) )
	 ogg? ( >=media-plugins/gst-plugins-ogg-0.10 )
	 theora? (
				>=media-plugins/gst-plugins-ogg-0.10
				>=media-plugins/gst-plugins-theora-0.10
			 )
	 vorbis? (
				>=media-plugins/gst-plugins-ogg-0.10
				>=media-plugins/gst-plugins-vorbis-0.10
			 )
	 xv? ( >=media-plugins/gst-plugins-xvideo-0.10 )"

# this belongs above xv? above.
# win32codecs? ( >=media-plugins/gst-plugins-pitfdll-0.10 )

DEPEND="${RDEPEND}
	  x11-proto/xproto
	  x11-proto/inputproto
	  app-text/scrollkeeper
	  gnome-base/gnome-common
	  app-text/gnome-doc-utils
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.20"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	# use global mozilla plugin dir
	G2CONF="${G2CONF} MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins"

	G2CONF="${G2CONF} --disable-vala --disable-vanity --enable-gstreamer --with-dbus"

	if use gnome ; then
	    G2CONF="${G2CONF} --disable-gtk --enable-nautilus"
	else
	    G2CONF="${G2CONF} --enable-gtk --disable-nautilus"
	fi

	if use nsplugin ; then
	    G2CONF="${G2CONF} --enable-browser-plugins"
		if use xulrunner ; then
			G2CONF="${G2CONF} --with-gecko=xulrunner"
		elif use seamonkey ; then
			G2CONF="${G2CONF} --with-gecko=seamonkey"
		else
			G2CONF="${G2CONF} --with-gecko=firefox"
		fi
	else
	    G2CONF="${G2CONF} --disable-browser-plugins"
	fi

	# Plugin Configuration
	G2CONF="${G2CONF} PLUGINDIR=/usr/$(get_libdir)/totem/plugins"

	local plugins="screensaver,ontop,gromit,skipto"
	use bluetooth && plugins="${plugins},bemused"
	use tracker && plugins="${plugins},tracker"
	use python && plugins="${plugins},youtube"
	use galago && plugins="${plugins},galago"
	use gnome && plugins="${plugins},media-player-keys,properties"
	use lirc && plugins="${plugins},lirc"

	G2CONF="${G2CONF} --with-plugins=${plugins}"

	G2CONF="${G2CONF}		\
		$(use_enable debug)	\
		$(use_with hal)		\
		$(use_enable lirc)	\
		$(use_enable nvtv)	\
		$(use_enable python)"
}

src_unpack() {
	local needs_xpcom_hack=$(use nsplugin && ! use xulrunner && ! use seamonkey)

	gnome2_src_unpack

	if use tracker ; then
		epatch "${FILESDIR}/${PN}-2.21.4-tracker-plugin.patch"
	fi

	use nsplugin && epatch "${FILESDIR}/${PN}-2.20.1-startup-notification.patch"
	$needs_xpcom_hack && epatch "${FILESDIR}/${PN}-2.20.1-xpcom-hack.patch"

	if use tracker || $needs_xpcom_hack ; then
		eautoreconf
	fi
}

src_compile() {
	#fixme: why does it need write access here, probably need to set up a fake
	#home in /var/tmp like other pkgs do

	addpredict "/root/.gconfd"
	addpredict "/root/.gconf"
	addpredict "/root/.gnome2"

	gnome2_src_compile
}
