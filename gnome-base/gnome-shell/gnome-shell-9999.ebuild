# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit eutils gnome2 python

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="http://live.gnome.org/GnomeShell"

LICENSE="GPL-2"
SLOT="0"
IUSE="nm-applet"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# gnome-desktop-2.91.2 is needed due to header changes, db82a33 in gnome-desktop
# FIXME: Automagic gnome-bluetooth[introspection] support.
COMMON_DEPEND=">=dev-libs/glib-2.25.9
	>=dev-libs/gjs-0.7.11
	>=dev-libs/gobject-introspection-0.10.1
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.0.0:3[introspection]
	>=media-libs/clutter-1.5.15[introspection]
	>=gnome-base/gnome-desktop-2.91.2:3
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-extra/evolution-data-server-2.91.6
	>=media-libs/gstreamer-0.10.16
	>=media-libs/gst-plugins-base-0.10.16
	>=net-libs/telepathy-glib-0.13.12[introspection]
	>=net-wireless/gnome-bluetooth-2.90.0[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=x11-wm/mutter-2.91.90[introspection]

	dev-libs/dbus-glib
	dev-libs/libxml2:2
	x11-libs/pango[introspection]
	dev-libs/libcroco:0.6

	gnome-base/gconf[introspection]
	gnome-base/gnome-menus
	gnome-base/librsvg
	media-libs/libcanberra
	media-sound/pulseaudio

	x11-libs/startup-notification
	x11-libs/libXfixes
	x11-apps/mesa-progs
	
	nm-applet? ( >=net-misc/networkmanager-9999[introspection] )"
# Runtime-only deps are probably incomplete and approximate.
RDEPEND="${COMMON_DEPEND}
	dev-python/dbus-python
	dev-python/gconf-python

	>=gnome-base/dconf-0.4.1
	>=gnome-base/gnome-settings-daemon-2.91
	>=gnome-base/gnome-control-center-2.91
	>=gnome-base/libgnomekbd-2.91.4[introspection]
	sys-power/upower[introspection]
	
	nm-applet? ( >=gnome-extra/nm-applet-9999 )"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"
DOCS="AUTHORS README"
# Don't error out on warnings
G2CONF="--enable-compile-warnings=maximum
--disable-schemas-compile"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	if use nm-applet; then
		# See https://bugzilla.gnome.org/show_bug.cgi?id=621707"
		ewarn "Adding support for the experimental NetworkManager applet."
		ewarn "This needs the latest NetworkManager & nm-applet trunk."
		ewarn "Report bugs about this to 'nirbheek' on #gentoo-desktop @ FreeNode."
		epatch "${FILESDIR}/${PN}-experimental-nm-applet-1.0.patch"
	fi

	gnome2_src_prepare
}

src_install() {
	python_convert_shebangs 2 tools/check-for-missing.py src/gnome-shell
	gnome2_src_install
}

pkg_postinst() {
	if ! has_version '>=media-libs/gst-plugins-good-0.10.23' || \
	   ! has_version 'media-plugins/gst-plugins-vp8'; then
		ewarn "To make use of GNOME Shell's built-in screen recording utility,"
		ewarn "you need to either install >=media-libs/gst-plugins-good-0.10.23"
		ewarn "and media-plugins/gst-plugins-vp8, or use dconf-editor to change"
		ewarn "/apps/gnome-shell/recorder/pipeline to what you want to use."
	fi
}
