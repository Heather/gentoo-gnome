# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson

DESCRIPTION="Manage your online calendars with simple and modern interface"
HOMEPAGE="https://wiki.gnome.org/Apps/Calendar"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.58.0:2
	>=dev-libs/libical-1.0.1
	>=gnome-base/gsettings-desktop-schemas-3.21.2
	>=gnome-extra/evolution-data-server-3.17.1:=
	>=net-libs/gnome-online-accounts-3.2.0:=
	>=x11-libs/gtk+-3.21.6:3
	>=dev-libs/libdazzle-3.27.1
	>=dev-libs/libgweather-3.27.4
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
"
