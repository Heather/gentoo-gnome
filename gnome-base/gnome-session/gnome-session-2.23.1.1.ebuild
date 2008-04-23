# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-session/gnome-session-2.22.1.1.ebuild,v 1.1 2008/04/10 22:53:29 eva Exp $

inherit eutils gnome2

DESCRIPTION="Gnome session manager"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI}
		 branding? ( mirror://gentoo/gentoo-splash.png )"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="branding ipv6"

RDEPEND=">=dev-libs/glib-2.16
		 >=gnome-base/libgnomeui-2.2
		 >=x11-libs/gtk+-2.11.1
		 >=dev-libs/dbus-glib-0.71
		 >=gnome-base/gnome-keyring-2.21.92
		 >=gnome-base/gconf-2
		 >=x11-libs/startup-notification-0.9

		  x11-apps/xrdb
		  x11-apps/xdpyinfo
		  x11-apps/setxkbmap"
DEPEND="${RDEPEND}
		>=sys-devel/gettext-0.10.40
		>=dev-util/pkgconfig-0.17
		>=dev-util/intltool-0.35
		!<gnome-base/gdm-2.20.4"

# gnome-base/gdm does not provide gnome.desktop anymore

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	# TODO: convert libnotify to a configure option
	G2CONF="${G2CONF} $(use_enable ipv6)"
}

src_unpack() {
	gnome2_src_unpack

	# Patch for Gentoo Branding (bug #42687)
	use branding && epatch "${FILESDIR}/${PN}-2.17.90.1-gentoo-branding.patch"
}

src_install() {
	gnome2_src_install

	dodir /etc/X11/Sessions
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome"

	# Our own splash for world domination
	if use branding ; then
		insinto /usr/share/pixmaps/splash/
		doins "${DISTDIR}/gentoo-splash.png"
	fi
}
