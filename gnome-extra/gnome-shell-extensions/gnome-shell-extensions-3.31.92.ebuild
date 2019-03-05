# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2 readme.gentoo-r1 meson

DESCRIPTION="JavaScript extensions for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell/Extensions"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.26:2
	>=gnome-base/libgtop-2.28.3[introspection]
	>=app-eselect/eselect-gnome-shell-extensions-20111211
"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/gjs-1.29
	dev-libs/gobject-introspection:=
	dev-libs/atk[introspection]
	>=gnome-base/gnome-menus-3.31.92:3[introspection]
	>=gnome-base/gnome-shell-${PV}
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	x11-themes/adwaita-icon-theme
	x11-wm/mutter[introspection]
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"
# eautoreconf needs gnome-base/gnome-common

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Installed extensions installed are initially disabled by default.
To change the system default and enable some extensions, you can use
# eselect gnome-shell-extensions

Alternatively, to enable/disable extensions on a per-user basis,
you can use the https://extensions.gnome.org/ web interface, the
gnome-extra/gnome-tweak-tool GUI, or modify the org.gnome.shell
enabled-extensions gsettings key from the command line or a script."

src_configure() {
	local emesonargs=(
		-Dextension_set='all'
		-Denabled_extensions="['alternate-tab', 'apps-menu', 'places-menu', 'launch-new-instance', 'window-list', 'drive-menu', 'screenshot-window-sizer', 'windowsNavigator', 'workspace-indicator', 'user-theme']"
	)
	meson_src_configure
}
