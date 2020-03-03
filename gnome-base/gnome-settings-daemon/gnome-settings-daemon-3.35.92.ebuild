# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{5,6,7} )

inherit eutils gnome.org python-any-r1 systemd udev virtualx meson

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="https://git.gnome.org/browse/gnome-settings-daemon"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord +cups debug kernel_linux +networkmanager policykit -smartcard test +udev wayland"
REQUIRED_USE="
	udev
	kernel_linux? ( networkmanager )
"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2[dbus]
	>=x11-libs/gtk+-3.15.3:3
	>=gnome-base/gsettings-desktop-schemas-3.23.3
	>=gnome-base/librsvg-2.36.2:2
	media-fonts/cantarell
	media-libs/alsa-lib
	>=media-libs/fontconfig-2.13.1
	>=media-libs/libcanberra-0.30[gtk3]
	>=media-sound/pulseaudio-12.2
	>=sys-power/upower-0.99.10:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.8:=
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/libXxf86misc
	x11-misc/xkeyboard-config

	>=app-misc/geoclue-2.5.3:2.0
	>=dev-libs/libgweather-3.32.2:2=
	>=sci-geosciences/geocode-glib-3.16.1
	>=sys-auth/polkit-0.113-r5

	>=media-libs/lcms-2.9:2
	colord? ( >=x11-misc/colord-1.3.5:= )
	cups? ( >=net-print/cups-2.2.12[dbus] )
	>=dev-libs/libwacom-0.29
	>=x11-libs/pango-1.20
	x11-drivers/xf86-input-wacom
	virtual/libgudev:=
	networkmanager? ( >=net-misc/networkmanager-1.18.4 )
	smartcard? ( >=dev-libs/nss-3.45 )
	udev? ( virtual/libgudev:= )
	wayland? ( >=dev-libs/wayland-1.17.0 )
"

BDEPEND="
	cups? ( sys-apps/sed )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

# Themes needed by g-s-d, gnome-shell, gtk+:3 apps to work properly
# <gnome-color-manager-3.1.1 has file collisions with g-s-d-3.1.x
# <gnome-power-manager-3.1.3 has file collisions with g-s-d-3.1.x
# systemd needed for power and session management, bug #464944
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	!<gnome-extra/gnome-color-manager-3.1.1
	!<gnome-extra/gnome-power-manager-3.1.3
	!<gnome-base/gnome-session-3.34.0
"

# xproto-7.0.15 needed for power plugin
# FIXME: tests require dbus-mock
DEPEND="${COMMON_DEPEND}
	dev-libs/libxml2:2
	dev-libs/libxslt
	sys-devel/gettext
	x11-base/xorg-proto
"

src_configure() {
	local emesonargs=(
		$(meson_use udev gudev)
		$(meson_use colord)
		$(meson_use cups)
		$(meson_use networkmanager network_manager)
		$(meson_use smartcard)
		$(meson_use wayland)
	)

	meson_src_configure
}
