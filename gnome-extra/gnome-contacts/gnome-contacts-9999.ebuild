# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.18"

inherit gnome2 vala
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://live.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
IUSE="v4l"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
	EGIT_HAS_SUBMODULES=true
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi
VALA_DEPEND="
	$(vala_depend)
	dev-libs/folks[vala]
	gnome-base/gnome-desktop[introspection]
	gnome-extra/evolution-data-server[vala]
	net-libs/telepathy-glib[vala]
	x11-libs/libnotify[introspection]
"
# Configure is wrong; it needs cheese-3.5.91, not 3.3.91
RDEPEND="
	>=dev-libs/folks-0.7.3:=[eds,telepathy]
	>=dev-libs/glib-2.31.10:2
	>=dev-libs/libgee-0.10:0.8
	>=gnome-extra/evolution-data-server-3.5.3:=[gnome-online-accounts]
	>=gnome-base/gnome-desktop-3.0:3=
	net-libs/gnome-online-accounts
	>=net-libs/telepathy-glib-0.17.5
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/libnotify:=
	>=x11-libs/gtk+-3.4:3
	x11-libs/pango
	v4l? ( >=media-video/cheese-3.5.91:= )
"
DEPEND="${RDEPEND}
	${VALA_DEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	# Regenerate the pre-generated C sources, bug #471628
	if ! use v4l; then
		touch src/*.vala
	fi

	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure $(use_with v4l cheese)
}
