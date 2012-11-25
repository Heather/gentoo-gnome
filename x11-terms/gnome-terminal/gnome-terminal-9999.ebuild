# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3+"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
fi
IUSE="nautilus"

# FIXME: automagic dependency on gtk+[X]
RDEPEND=">=dev-libs/glib-2.33.2:2
	>=x11-libs/gtk+-3.5.3:3[X]
	>=x11-libs/vte-0.33.0:2.90
	>=gnome-base/dconf-0.13.4
	>=gnome-base/gconf-2.31.3:2
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/dbus
	nautilus? ( >=gnome-base/nautilus-3 )"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/gdbus-codegen
	dev-util/gtk-builder-convert
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="${G2CONF}
		$(use_with nautilus nautilus-extension)"

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst
	if [[ ${REPLACING_VERSIONS} < 3.6.1-r1 && ${REPLACING_VERSIONS} != 2.32.1-r1 &&
	      ${REPLACING_VERSIONS} != 3.4.1.1-r1 ]]; then
		elog "Gnome Terminal no longer uses login shell by default, switching"
		elog "to upstream default. Because of this, if you have some command you"
		elog "want to be run, be sure to have it placed in your ~/.bashrc file."
	fi
}
