# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Gnome session manager"
HOMEPAGE="https://git.gnome.org/browse/gnome-session"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc systemd man"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).
# gdk-pixbuf used in the inhibit dialog
COMMON_DEPEND="
	>=dev-libs/glib-2.58.0:2[dbus]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.18.0:3
	>=dev-libs/json-glib-0.10
	>=gnome-base/gnome-desktop-3.27.90:3

	media-libs/mesa[egl,gles2]

	media-libs/libepoxy
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	x11-apps/xdpyinfo

	systemd? ( >=sys-apps/systemd-183:0= )
"

BDEPEND="
	doc? (
		app-text/xmlto
		dev-libs/libxslt
	)
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
"

# Pure-runtime deps from the session files should *NOT* be added here
# Otherwise, things like gdm pull in gnome-shell
# gnome-themes-standard is needed for the failwhale dialog themeing
# sys-apps/dbus[X] is needed for session management
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-settings-daemon-3.34.0
	>=gnome-base/gsettings-desktop-schemas-3.28.1
	x11-themes/adwaita-icon-theme
	sys-apps/dbus[X]
	!systemd? (
		sys-auth/consolekit
		>=dev-libs/dbus-glib-0.76
	)
"

DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=sys-devel/gettext-0.10.40
	!<gnome-base/gdm-2.20.4
"

src_configure() {
	local emesonargs=(
		$(meson_use systemd)
		$(meson_use systemd systemd_journal)
		$(meson_use !systemd consolekit)
		$(meson_use doc docbook)
		$(meson_use man)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version gnome-base/gdm && ! has_version x11-misc/sddm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi

	if ! use systemd && ! use elogind && ! use consolekit; then
		ewarn "You are building without systemd, elogind and/or consolekit support."
		ewarn "gnome-session won't be able to correctly track and manage your session."
	fi
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
