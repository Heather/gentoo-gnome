# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="http://live.gnome.org/Gnote"

LICENSE="GPL-3+"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="debug"

# Automagic glib-2.32 dep
COMMON_DEPEND="
	>=app-crypt/libsecret-0.8
	>=dev-cpp/glibmm-2.28:2
	>=dev-cpp/gtkmm-3.4:3.0
	>=dev-libs/boost-1.34
	>=dev-libs/glib-2.32
	>=dev-libs/libxml2-2:2
	dev-libs/libxslt
	>=sys-apps/util-linux-2.16
	>=x11-libs/gtk+-3:3
	x11-libs/libX11
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gsettings-desktop-schemas"
DEPEND="${DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"
if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools"
fi

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable debug)"
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"

	# Do not alter CFLAGS
	sed 's/-DDEBUG -g/-DDEBUG/' -i configure.ac configure || die

	gnome2_src_prepare
}
