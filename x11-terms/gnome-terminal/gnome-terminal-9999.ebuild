# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
fi
IUSE="nautilus"

# FIXME: automagic dependency on gtk+[X]
RDEPEND=">=dev-libs/glib-2.33.1:2
	>=x11-libs/gtk+-3.5.3:3[X]
	>=x11-libs/vte-0.32.1:2.90
	gnome-base/dconf
	>=gnome-base/gconf-2.31.3:2
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/dbus
	nautilus? ( >=gnome-base/nautilus-3 )"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3.11
	dev-libs/libxml2
	dev-util/gdbus-codegen
	dev-util/gtk-builder-convert
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="${G2CONF}
		$(use_with nautilus nautilus-extension)"
}

src_prepare() {
	# Use login shell by default (#12900)
	epatch "${FILESDIR}"/${PN}-3.5.0-default_shell.patch

	gnome2_src_prepare
}
