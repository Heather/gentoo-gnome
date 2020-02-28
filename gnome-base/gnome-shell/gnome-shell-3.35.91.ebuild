# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )

inherit gnome.org gnome2-utils meson pax-utils python-single-r1 virtualx xdg

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+bluetooth browser-extension elogind +ibus +networkmanager nsplugin systemd telepathy"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( elogind systemd )"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"

COMMON_DEPEND="
	>=dev-libs/libcroco-0.6.8:0.6
	>=gnome-extra/evolution-data-server-3.34.1:=
	>=app-crypt/gcr-3.7.5[introspection]
	>=gnome-base/gnome-desktop-3.34.2-r1:3=[introspection]
	>=dev-libs/glib-2.53.0:2
	>=dev-libs/gobject-introspection-1.49.1:=
	>=dev-libs/gjs-1.63.2
	>=x11-libs/gtk+-3.15.0:3[introspection]
	nsplugin? ( >=dev-libs/json-glib-0.13.2 )
	>=x11-wm/mutter-3.35.2[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=gnome-base/gsettings-desktop-schemas-3.33.1
	>=x11-libs/startup-notification-0.11
	>=net-wireless/gnome-bluetooth-3.9[introspection]
	>=media-libs/gstreamer-0.11.92:1.0
	networkmanager? (
		>=gnome-extra/nm-applet-0.9.8[introspection]
		>=net-misc/networkmanager-0.9.8:=[introspection]
		>=app-crypt/libsecret-0.18
		dev-libs/dbus-glib )
	systemd? ( >=sys-apps/systemd-31 )
	elogind? ( >=sys-auth/elogind-237 )

	>=app-accessibility/at-spi2-atk-2.5.3
	media-libs/libcanberra[gtk3]
	x11-libs/gdk-pixbuf:2[introspection]
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.40:2.4[introspection]
	x11-libs/libX11

	>=media-sound/pulseaudio-2[glib]
	>=dev-libs/atk-2[introspection]
	dev-libs/libical:=
	>=x11-libs/libXfixes-5.0

	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
	media-libs/mesa[X(+)]
"

# Runtime-only deps are probably incomplete and approximate.
# Introspection deps generated using:
#  grep -roe "imports.gi.*" gnome-shell-* | cut -f2 -d: | sort | uniq
# Each block:
# 1. Introspection stuff needed via imports.gi.*
# 2. gnome-session needed for shutdown/reboot/inhibitors/etc
# 3. Control shell settings
# 4. logind interface needed for suspending support
# 5. xdg-utils needed for xdg-open, used by extension tool
# 6. adwaita-icon-theme needed for various icons & arrows (3.26 for new video-joined-displays-symbolic and co icons; review for 3.28+)
# 7. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c  # TODO: Review
# 8. IBus is needed for nls integration
# 9. Optional telepathy chat integration
# 10. TODO: semi-optional webkit-gtk[introspection] for captive portal helper
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/accountsservice-0.6.14[introspection]
	app-accessibility/at-spi2-core:2[introspection]
	>=app-accessibility/caribou-0.4.8
	app-misc/geoclue[introspection]
	>=dev-libs/libgweather-3.26:2[introspection]
	>=sys-power/upower-0.99:=[introspection]
	x11-libs/pango[introspection]
	gnome-base/librsvg:2[introspection]

	>=gnome-base/gnome-session-3.34.0
	>=gnome-base/gnome-settings-daemon-3.34.1

	x11-misc/xdg-utils

	>=x11-themes/adwaita-icon-theme-3.26

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
	ibus? ( >=app-i18n/ibus-1.4.99[dconf(+),gtk,introspection] )
	telepathy? (
		>=net-im/telepathy-logger-0.2.4[introspection]
		>=net-libs/telepathy-glib-0.19[introspection] )
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.34.1[introspection]
	>=gnome-base/gnome-control-center-3.34.0
	browser-extension? ( gnome-extra/chrome-gnome-shell )
"

DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.45.3
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

PATCHES=(
	# Change favorites defaults, bug #479918
	# "${FILESDIR}"/${PN}-3.22.0-defaults.patch
)

src_prepare() {
	xdg_src_prepare
	# We want nsplugins in /usr/$(get_libdir)/nsbrowser/plugins not .../mozilla/plugins
	sed -e 's/mozilla/nsbrowser/' -i meson.build || die
	# Hack in correct python shebang
	sed -e "s:python\.path():'/usr/bin/env ${EPYTHON}':" -i src/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use nsplugin enable-browser-plugin)
		-Denable-man=true
		-Denable-bluetooth=$(usex bluetooth yes no)
		-Denable-networkmanager=$(usex networkmanager yes no)
		-Denable-systemd=$(usex systemd yes no)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# Required for gnome-shell on hardened/PaX, bug #398941; FIXME: Is this still relevant?
	pax-mark m "${ED}usr/bin/gnome-shell"{,-extension-prefs}
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version 'media-libs/gst-plugins-good:1.0' || \
	   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
		ewarn "To make use of GNOME Shell's built-in screen recording utility,"
		ewarn "you need to either install media-libs/gst-plugins-good:1.0"
		ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
		ewarn "apps.gnome-shell.recorder/pipeline to what you want to use."
	fi

	if ! has_version "media-libs/mesa[llvm]"; then
		elog "llvmpipe is used as fallback when no 3D acceleration"
		elog "is available. You will need to enable llvm USE for"
		elog "media-libs/mesa if you do not have hardware 3D setup."
	fi

	# https://bugs.gentoo.org/show_bug.cgi?id=563084
	if has_version "x11-drivers/nvidia-drivers[-kms]"; then
		ewarn "You will need to enable kms support in x11-drivers/nvidia-drivers,"
		ewarn "otherwise Gnome will fail to start"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
