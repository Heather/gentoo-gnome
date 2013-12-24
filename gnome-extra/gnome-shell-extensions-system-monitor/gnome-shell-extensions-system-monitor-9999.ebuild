# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"

EGIT_REPO_URI="git://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

inherit gnome2-utils gnome2-live python

DESCRIPTION="System monitor extension for GNOME Shell"
HOMEPAGE="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="" #"~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-3:3
	app-admin/eselect-gnome-shell-extensions"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	gnome-base/gnome-shell
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.26
	virtual/pkgconfig
	gnome-base/gnome-common"

src_prepare() {
	python_convert_shebangs 2 *.py
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install()	{
	insinto /usr/share/gnome-shell/extensions
	doins -r system-monitor@paradoxxx.zero.gmail.com || die

	insinto /usr/share/glib-2.0/schemas
	doins org.gnome.shell.extensions.system-monitor.gschema.xml || die

	mv system-monitor-applet-config{.py,}
	dobin system-monitor-applet-config || die

	insinto /usr/share/applications
	doins system-monitor-applet-config.desktop || die
}

pkg_postinst() {
	gnome2_pkg_postinst

	einfo "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, you can use the org.gnome.shell disabled-extensions"
	elog "gsettings key to change the disabled extension list per-user."
	elog
}
