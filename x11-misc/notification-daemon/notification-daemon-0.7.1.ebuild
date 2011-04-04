# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/notification-daemon/notification-daemon-0.5.0.ebuild,v 1.1 2011/01/24 23:22:25 eva Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Notification daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.27:2
	>=x11-libs/gtk+-2.91:3
	>=sys-apps/dbus-1
	>=media-libs/libcanberra-0.4[gtk3]
	x11-libs/libnotify
	x11-libs/libX11
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.14
"
RDEPEND="${COMMON_DEPEND}
	!xfce-extra/xfce4-notifyd
	!x11-misc/notify-osd
"

DOCS="AUTHORS ChangeLog NEWS"
