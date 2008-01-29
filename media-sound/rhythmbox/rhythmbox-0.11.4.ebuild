# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-0.11.2-r1.ebuild,v 1.4 2008/01/29 18:22:35 dang Exp $
EAPI="1"

inherit gnome2 eutils

EAPI="1"

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="doc vorbis flac mad ipod hal daap dbus libnotify lirc musicbrainz tagwriting python keyring"
#I want tagwriting to be on by default in the future. It is just a local flag
#now because it is still considered experimental by upstream and doesn't work
#well with all formats due to gstreamer limitation.

# We will probably want to activate crossfade backend at some point via USE flag

SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.8
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=gnome-base/gnome-vfs-2.8
	>=dev-libs/totem-pl-parser-2.21.4
	>=gnome-extra/nautilus-cd-burner-2.13
	>=x11-libs/libsexy-0.1.5
	>=gnome-extra/gnome-media-2.14.0
	>=media-plugins/gst-plugins-cdparanoia-0.10
	keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	musicbrainz? ( >=media-libs/musicbrainz-2.1:1 )
	>=net-libs/libsoup-2.2.99:2.2
	lirc? ( app-misc/lirc )
	hal? ( ipod? ( >=media-libs/libgpod-0.4 )
			>=sys-apps/hal-0.5 )
	daap? ( >=net-dns/avahi-0.6 )
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	>=media-libs/gst-plugins-base-0.10.11
	>=media-plugins/gst-plugins-gnomevfs-0.10
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10
				>=media-plugins/gst-plugins-ogg-0.10 )
	mad? ( >=media-plugins/gst-plugins-mad-0.10 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10 )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )
	python? ( >=dev-lang/python-2.4.2
				>=dev-python/pygtk-2.8
				>=dev-python/gnome-python-2.12 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35
	app-text/scrollkeeper"

pkg_setup() {

	if ! use hal && use ipod; then
		ewarn "ipod support requires hal support.  Please"
		ewarn "re-emerge with USE=hal to enable ipod support"
	fi

	if use daap ; then
		G2CONF="${G2CONF} --enable-daap --with-mdns=avahi"
	else
		G2CONF="${G2CONF} --disable-daap"
	fi

	G2CONF="${G2CONF} \
	$(use_enable tagwriting tag-writing) \
	$(use_with ipod) \
	$(use_enable ipod ipod-writing) \
	$(use_enable musicbrainz) \
	$(use_with dbus) \
	$(use_enable python) \
	$(use_enable libnotify) \
	$(use_enable lirc) \
	$(use_with keyring gnome-keyring)
	--with-playback=gstreamer-0-10 \
	--with-cd-burning
	--enable-mmkeys \
	--enable-audioscrobbler \
	--enable-track-transfer \
	--with-metadata-helper \
	--disable-schemas-install"

DOCS="AUTHORS COPYING ChangeLog DOCUMENTERS INSTALL INTERNALS \
	  MAINTAINERS NEWS README README.iPod THANKS TODO"

export GST_INSPECT=/bin/true
USE_DESTDIR=1
}

src_compile() {
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "The aac flag has been removed from rhythmbox."
	elog "This is due to stabilization issues with any gst-bad plugins."
	elog "Please emerge gst-plugins-bad and gst-plugins-faad to be able to play m4a files"
	elog "See bug #159538 for more information"
}
