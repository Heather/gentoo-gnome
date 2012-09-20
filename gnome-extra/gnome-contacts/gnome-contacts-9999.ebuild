# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.18"

inherit gnome2 vala
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://live.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2"
SLOT="0"
IUSE="v4l"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
VALA_DEPEND="$(vala_depend)
	net-libs/telepathy-glib[vala]"
# Configure is wrong; it needs cheese-3.5.91, not 3.3.91
RDEPEND="
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.4:3
	>=gnome-extra/evolution-data-server-3.5.3[gnome-online-accounts]
	>=gnome-base/gnome-desktop-3.0:3
	>=net-libs/telepathy-glib-0.17.5
	>=dev-libs/folks-0.7.2[eds]

	v4l? ( >=media-video/cheese-3.5.91 )

	dev-libs/libgee:0
	net-libs/gnome-online-accounts
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libnotify
	x11-libs/pango"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	!v4l? ( ${VALA_DEPEND} )"
# When !v4l, we regenerate the .c sources

if [[ ${PV} = 9999 ]]; then
	DEPEND+="
		${VALA_DEPEND}"
fi

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS" # README is empty
	# We do not need valac when building from pre-generated C sources,
	# but configure checks for it anyway
	G2CONF="${G2CONF}
		VALAC=$(type -P valac-$(vala_best_api_version))
		$(use_with v4l cheese)"
	# FIXME: Fails to compile with USE=-v4l
}

src_prepare() {
	# Regenerate the pre-generated C sources
	if ! use v4l; then
		touch src/*.vala
	fi
	# We don't want vala_src_prepare
	gnome2_src_prepare
}
