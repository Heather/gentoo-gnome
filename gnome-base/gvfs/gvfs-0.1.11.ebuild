# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools gnome2

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi bluetooth cdda doc fuse gnome gphoto2 hal keyring samba"

RDEPEND="=dev-libs/glib-2.15.6
		 >=sys-apps/dbus-1.0
		 >=net-libs/libsoup-2.3.0
		   net-misc/openssh
		 avahi? ( >=net-dns/avahi-0.6 )
		 bluetooth? ( >=net-wireless/bluez-libs-3.12 dev-libs/expat )
		 cdda? ( >=dev-libs/libcdio-0.78.2 )
		 fuse? ( sys-fs/fuse )
		 gnome? ( >=gnome-base/gconf-2.0 )
		 gphoto2? ( media-gfx/gphoto2 )
		 hal? ( >=sys-apps/hal-0.5.9 )
		 keyring? ( >=gnome-base/gnome-keyring-1.0 )
		 samba? ( >=net-fs/samba-3 )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19
		doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="--enable-http
			$(use_enable avahi)
			$(use_enable bluetooth obexftp)
			$(use_enable doc gtk-doc)
			$(use_enable cdda)
			$(use_enable fuse)
			$(use_enable gnome gconf)
			$(use_enable gphoto2)
			$(use_enable hal)
			$(use_enable keyring)
			$(use_enable samba)"
}
