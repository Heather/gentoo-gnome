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
IUSE="doc +cheese +cups +networkmanager +socialweb"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

# XXX: gnome-desktop-2.91.5 is needed for upstream commit c67f7efb
# XXX: NetworkManager-0.9 support is automagic, make hard-dep once it's released
#
# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d-2.91.90.1 is needed for magnifier schema updates
# Latest gsettings-desktop-schemas is needed for commit 73f9bffb
COMMON_DEPEND="
	>=dev-libs/glib-2.25.11:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.0.2:3
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=gnome-base/gconf-2.0:2
	>=dev-libs/dbus-glib-0.73
	>=gnome-base/gnome-desktop-2.91.5:3
	>=gnome-base/gnome-settings-daemon-2.91.90.1
	>=gnome-base/libgnomekbd-2.91.91

	app-text/iso-codes
	dev-libs/libxml2:2
	gnome-base/gnome-menus
	gnome-base/libgtop:2
	media-libs/fontconfig

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-0.9.16
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.9.1

	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.1
	>=x11-libs/libXi-1.2

	cheese? (
		media-libs/gstreamer:0.10
		>=media-video/cheese-2.91.91.1 )
	cups? ( >=net-print/cups-1.4[dbus] )
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
	
	cups? ( sys-apps/sed )
	doc? ( >=dev-util/gtk-doc-1.9 )"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-static
		--disable-schemas-install
		$(use_with cheese)
		$(use_enable cups)
		$(use_with socialweb libsocialweb)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"

	# https://bugs.gentoo.org/show_bug.cgi?id=360057
	epatch "${FILESDIR}/${P}-fix-desktop-file.patch"

	gnome2_src_prepare
}
