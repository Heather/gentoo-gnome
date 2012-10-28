# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gnote/gnote-0.7.4.ebuild,v 1.1 2011/05/02 21:02:38 eva Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="http://live.gnome.org/Gnote"

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="debug"

RDEPEND="
	>=app-crypt/libsecret-0.8
	>=dev-cpp/glibmm-2.28:2
	>=dev-cpp/gtkmm-3.4:3.0
	>=dev-libs/boost-1.34
	>=dev-libs/libxml2-2:2
	>=sys-apps/util-linux-2.16
	>=x11-libs/gtk+-3.0:3
	dev-libs/libxslt
	x11-libs/libX11
"
DEPEND="${DEPEND}
	app-text/yelp-tools
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		$(use_enable debug)"

	# Do not alter CFLAGS
	sed 's/-DDEBUG -g/-DDEBUG/' -i configure.ac configure || die

	gnome2_src_prepare
}
