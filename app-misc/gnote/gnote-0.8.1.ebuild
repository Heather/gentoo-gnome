# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gnote/gnote-0.7.4.ebuild,v 1.1 2011/05/02 21:02:38 eva Exp $

EAPI="4"
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
IUSE="applet debug"

RDEPEND=">=x11-libs/gtk+-3.0:3
	>=dev-cpp/glibmm-2.28:2
	>=dev-cpp/gtkmm-3.0:3.0
	>=dev-libs/libxml2-2:2
	dev-libs/libxslt
	>=dev-libs/libpcre-7.8:3[cxx]
	>=dev-libs/boost-1.34
	>=sys-apps/util-linux-2.16
	applet? ( >=gnome-base/gnome-panel-3 )"
DEPEND="${DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		$(use_enable applet)
		$(use_enable debug)"
}

src_prepare() {
	gnome2_src_prepare

	# Do not set idiotic defines in a released tarball, bug #311979
	sed 's/-DG.*_DISABLE_DEPRECATED//g' -i libtomboy/Makefile.* ||
		die "sed failed"
}
