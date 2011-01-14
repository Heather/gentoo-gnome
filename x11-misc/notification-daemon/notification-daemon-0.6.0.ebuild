# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/notification-daemon/notification-daemon-0.4.0-r1.ebuild,v 1.10 2010/03/26 16:45:43 ssuominen Exp $

EAPI="3"

inherit gnome2

DESCRIPTION="Notifications daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.18.0
	>=x11-libs/gtk+-2.18.0:2
	>=gnome-base/gconf-2
	>=dev-libs/dbus-glib-0.78
	>=sys-apps/dbus-1
	>=media-libs/libcanberra-0.4[gtk]
	x11-libs/libwnck
	x11-libs/libX11
	x11-libs/libnotify"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.11"
RDEPEND="${COMMON_DEPEND}
	!xfce-extra/xfce4-notifyd"

DOCS="AUTHORS ChangeLog NEWS"
