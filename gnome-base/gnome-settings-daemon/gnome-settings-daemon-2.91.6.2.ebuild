# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-settings-daemon/gnome-settings-daemon-2.32.1.ebuild,v 1.1 2010/12/04 16:50:12 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="http://www.gnome.org"
SRC_URI="${SRC_URI}
	mirror://gentoo/${PN}-2.30.0-gst-vol-control-support.patch"
# mirror://gentoo/${PN}-2.30.2-gst-vol-control-support.patch.bz2"
# New patch has other problems like bug #339732

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug libnotify policykit pulseaudio smartcard"

RDEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.26.0
	>=x11-libs/gtk+-2.91.6
	>=gnome-base/gconf-2.6.1
	>=gnome-base/libgnomekbd-2.91.1
	>=gnome-base/gnome-desktop-2.91.3:3
	>=gnome-base/gsettings-desktop-schemas-0.1.2
	media-libs/fontconfig

	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.0

	libnotify? ( >=x11-libs/libnotify-0.6.1 )
	policykit? (
		>=sys-auth/polkit-0.97
		>=sys-apps/dbus-1.1.2 )
	pulseaudio? (
		>=media-sound/pulseaudio-0.9.16
		media-libs/libcanberra[gtk] )
	!pulseaudio? (
		>=media-libs/gstreamer-0.10.1.2
		>=media-libs/gst-plugins-base-0.10.1.2 )
	smartcard? ( >=dev-libs/nss-3.11.2 )"

DEPEND="${RDEPEND}
	!<gnome-base/gnome-control-center-2.22
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	x11-proto/inputproto
	x11-proto/xproto"

pkg_setup() {
	# README is empty
	DOCS="AUTHORS NEWS ChangeLog MAINTAINERS"
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-install
		--enable-gconf-bridge
		$(use_enable debug)
		$(use_with libnotify)
		$(use_enable policykit polkit)
		$(use_enable pulseaudio pulse)
		$(use_enable !pulseaudio gstreamer)
		$(use_enable smartcard smartcard-support)"

	if use pulseaudio; then
		elog "Building volume media keys using Pulseaudio"
	else
		elog "Building volume media keys using GStreamer"
	fi
}

src_prepare() {
	gnome2_src_prepare

	# Restore gstreamer volume control support, upstream bug #571145
	# Keep using old patch as it doesn't cause problems like bug #339732
	#epatch "${WORKDIR}/${PN}-2.30.2-gst-vol-control-support.patch"
	#echo "plugins/media-keys/cut-n-paste/gvc-gstreamer-acme-vol.c" >> po/POTFILES.in

	epatch "${DISTDIR}/${PN}-2.30.0-gst-vol-control-support.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! use pulseaudio; then
		elog "GStreamer volume control support is a feature powered by Gentoo GNOME Team"
		elog "PLEASE DO NOT report bugs upstream, report on https://bugs.gentoo.org instead"
	fi
}
