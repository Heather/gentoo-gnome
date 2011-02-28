# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-control-center/gnome-control-center-2.32.1.ebuild,v 1.1 2010/12/04 00:46:57 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # gmodule is used, which uses dlopen

inherit gnome2

DESCRIPTION="GNOME Desktop Configuration Tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="2"
IUSE="doc +networkmanager +socialweb"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

# WTF: pulseaudio is compulsary now for gnome-volume-control
# FIXME: Cheese is optional, but automagic => force-enabled for now
# FIXME: Cups is optional, but automagic => force-enabled for now
# XXX: gnome-desktop-2.91.5 is needed for upstream commit c67f7efb
#
# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
COMMON_DEPEND="
	>=dev-libs/glib-2.25.11
	>=x11-libs/gdk-pixbuf-2.23.0
	>=x11-libs/gtk+-2.91.6:3
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-base/gconf-2.0
	>=dev-libs/dbus-glib-0.73
	>=gnome-base/gnome-desktop-2.91.5:3
	>=gnome-base/gnome-settings-daemon-2.91.9
	>=gnome-base/libgnomekbd-2.91.2

	app-text/iso-codes
	dev-libs/libxml2:2
	gnome-base/gnome-menus
	gnome-base/libgtop:2
	media-libs/fontconfig
	media-libs/gstreamer:0.10

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-0.9.16
	>=media-video/cheese-2.29.90
	>=net-print/cups-1.4
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.9.1

	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.1
	>=x11-libs/libXi-1.2

	networkmanager? ( >=net-misc/networkmanager-0.8.992 )
	socialweb? ( net-libs/libsocialweb )

	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300"
RDEPEND="${COMMON_DEPEND}
	sys-apps/accountsservice"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40.1
	>=dev-util/pkgconfig-0.19

	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.10.1
	doc? ( >=dev-util/gtk-doc-1.9 )"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-static
		--disable-schemas-install
		$(use_with socialweb libsocialweb)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"

	gnome2_src_prepare
}
