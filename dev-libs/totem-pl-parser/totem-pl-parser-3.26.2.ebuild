# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
inherit gnome2 meson

DESCRIPTION="Playlist parsing library"
HOMEPAGE="https://developer.gnome.org/totem-pl-parser/stable/"

LICENSE="LGPL-2+"
SLOT="0/18"
IUSE="archive crypt +introspection +quvi test"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=net-libs/libsoup-2.43:2.4
	archive? ( >=app-arch/libarchive-3 )
	crypt? ( dev-libs/libgcrypt:0= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	quvi? ( >=media-libs/libquvi-0.9.1:0= )
"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	dev-libs/gobject-introspection-common
	>=dev-util/intltool-0.35
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.14
	sys-devel/autoconf-archive
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	test? (
		gnome-base/gvfs[http]
		sys-apps/dbus )
"

src_prepare() {
	default
}
