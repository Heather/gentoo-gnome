# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

EGIT_REPO_URI="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

inherit gnome2-utils gnome2-live

DESCRIPTION="System monitor extension for GNOME Shell"
HOMEPAGE="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-3:3"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

src_prepare() {
	:
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install()	{
	insinto /usr/share/gnome-shell/extensions
	doins -r system-monitor@paradoxxx.zero.gmail.com

	insinto /usr/share/glib-2.0/schemas
	doins org.gnome.shell.extensions.system-monitor.gschema.xml

	mv system-monitor-applet-config{.py,}
	dobin system-monitor-applet-config

	insinto /usr/share/applications
	doins system-monitor-applet-config.desktop
}
