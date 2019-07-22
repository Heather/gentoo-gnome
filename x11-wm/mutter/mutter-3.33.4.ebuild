# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 virtualx meson

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="https://git.gnome.org/browse/mutter/"

LICENSE="GPL-2+"
SLOT="0"

IUSE="elogind +gles2 input_devices_wacom +introspection systemd udev wayland"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# libXi-1.7.4 or newer needed per:
# https://bugzilla.gnome.org/show_bug.cgi?id=738944
# TODO: make wayland? ( optional, update patch
COMMON_DEPEND="
	>=dev-libs/atk-2.5.3
	>=x11-libs/gdk-pixbuf-2:2
	>=dev-libs/json-glib-0.12.0
	>=x11-libs/pango-1.30[introspection?]
	>=x11-libs/cairo-1.14[X]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	>=dev-libs/glib-2.60.0:2[dbus]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.21.4[introspection?]
	gnome-base/gnome-desktop:3=
	>sys-power/upower-0.99:=
	>=dev-util/sysprof-3.33.3

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.4
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	>=x11-libs/libXfixes-3
	>=x11-libs/libXi-1.7.4
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.5
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbfile
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-misc/xkeyboard-config

	gnome-extra/zenity
	media-libs/mesa[egl]

	gles2? ( media-libs/mesa[gles2] )
	input_devices_wacom? ( >=dev-libs/libwacom-0.13 )
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	>=dev-libs/libinput-1.4
	>=dev-libs/wayland-1.6.90
	>=dev-libs/wayland-protocols-1.16
	>=media-libs/mesa-10.3[egl,gbm,wayland]
	systemd? ( sys-apps/systemd:= )
	elogind? ( sys-auth/elogind )
	>=virtual/libudev-232:=
	x11-base/xorg-server[wayland]
	x11-libs/libdrm:=

	media-video/pipewire
"

DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
	>=sys-kernel/linux-headers-4.4
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

meson_use_enable() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

src_configure() {
	sed -i "/'-Werror=redundant-decls',/d" "${S}"/meson.build || die "sed failed"

	local emesonargs=(
		-Dopengl=true
		-Degl=true
		-Dglx=true
		-Dsm=true
		$(meson_use gles2)
		$(meson_use gles2 native_backend)
		$(meson_use wayland)
		$(meson_use udev)
		$(meson_use input_devices_wacom libwacom)
	)

	meson_src_configure
}
