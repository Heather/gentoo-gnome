# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
#	EGIT_BRANCH="gnome-3-0"
	inherit gnome2-live
fi

DESCRIPTION="JavaScript extensions for GNOME Shell"
HOMEPAGE="http://live.gnome.org/GnomeShell/Extensions"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-2.91.6:3[introspection]
	>=gnome-base/libgtop-2.28.3[introspection]
	app-admin/eselect-gnome-shell-extensions"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/gjs-1.29
	dev-libs/gobject-introspection
	=gnome-base/gnome-shell-3.2*
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

pkg_setup() {
	DOCS="NEWS README"
	G2CONF="${G2CONF}
		--enable-extensions=all
		--disable-schemas-compile"
}

src_prepare() {
	gnome2_src_prepare

	# Fix popup menus in dock extension; will be in next release
	epatch "${FILESDIR}/${P}-dock-popup-menus.patch"

	# xrandr-indicator crashes gnome-shell with <gjs-0.7.15;
	# see gnome bug 649077. For simplicity, just disable it for gnome-3.0.
	# sed -e 's:\(ALL_EXTENSIONS=.*\)xrandr-indicator:\1:' \
	#	-i configure || die
}

src_install() {
	gnome2_src_install

	local example="example@gnome-shell-extensions.gnome.org"
	if use examples; then
		mv "${ED}usr/share/gnome-shell/extensions/${example}" \
			"${ED}usr/share/doc/${PF}/" || die
	else
		rm -r "${ED}usr/share/gnome-shell/extensions/${example}" || die
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	einfo "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, you can use the org.gnome.shell enabled-extensions"
	elog "gsettings key to change the disabled extension list per-user."
	elog
}
