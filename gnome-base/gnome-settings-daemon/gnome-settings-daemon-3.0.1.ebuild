# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-settings-daemon/gnome-settings-daemon-2.32.1.ebuild,v 1.1 2010/12/04 16:50:12 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi
IUSE="+cups debug packagekit policykit smartcard +udev"

# Latest gsettings-desktop-schemas is needed due to commit e8d1de92
COMMON_DEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.26.0:2
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-base/gconf-2.6.1:2
	>=gnome-base/libgnomekbd-2.91.1
	>=gnome-base/gnome-desktop-2.91.5:3
	>=gnome-base/gsettings-desktop-schemas-0.1.7.1
	media-fonts/cantarell
	media-libs/fontconfig

	>=x11-libs/libnotify-0.6.1
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.0
	>=media-sound/pulseaudio-0.9.16
	media-libs/libcanberra[gtk3]

	cups? ( >=net-print/cups-1.4[dbus] )
	packagekit? (
		dev-libs/glib:2
		sys-fs/udev[extras]
		>=app-portage/packagekit-0.6.4
		>=sys-power/upower-0.9.1 )
	policykit? (
		>=sys-auth/polkit-0.97
		>=sys-apps/dbus-1.1.2 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	udev? ( sys-fs/udev[extras] )"
# Themes needed by g-s-d, gnome-shell, gtk+:3 apps to work properly
RDEPEND="${COMMON_DEPEND}
	>=x11-themes/gnome-themes-standard-2.91
	>=x11-themes/gnome-icon-theme-2.91
	>=x11-themes/gnome-icon-theme-symbolic-2.91
	!<gnome-base/gnome-control-center-2.22"
DEPEND="${COMMON_DEPEND}
	cups? ( sys-apps/sed )
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
		--disable-schemas-compile
		--enable-gconf-bridge
		$(use_enable cups)
		$(use_enable debug)
		$(use_enable debug more-warnings)
		$(use_enable packagekit)
		$(use_enable policykit polkit)
		$(use_enable smartcard smartcard-support)
		$(use_enable udev gudev)"
}


src_install() {
	gnome2_src_install

	echo 'GSETTINGS_BACKEND="dconf"' >> 51gsettings-dconf
	doenvd 51gsettings-dconf || die "doenvd failed"
}
