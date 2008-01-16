# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-session/gnome-session-2.20.3.ebuild,v 1.1 2008/01/09 22:02:27 eva Exp $

inherit eutils gnome2

DESCRIPTION="Gnome session manager"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI}
		 branding? ( mirror://gentoo/gentoo-splash.png )"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="branding esd ipv6 tcpd"

RDEPEND=">=dev-libs/glib-2.13
		 >=x11-libs/gtk+-2.11.1
		 x11-libs/libXau
		 x11-apps/xdpyinfo
		 >=gnome-base/libgnomeui-2.2
		 >=gnome-base/control-center-2.15.4
		 >=x11-libs/libnotify-0.2.1
		 >=gnome-base/gconf-2
		 >=gnome-base/gnome-keyring-0.5.1
		 >=dev-libs/dbus-glib-0.71
		 esd? ( >=media-sound/esound-0.2.26 )
		 tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"
DEPEND="${RDEPEND}
		  x11-apps/xrdb
		>=sys-devel/gettext-0.10.40
		>=dev-util/pkgconfig-0.17
		>=dev-util/intltool-0.35
		!gnome-base/gnome-core"

# gnome-base/gnome-core overwrite /usr/bin/gnome-session
DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	# TODO: convert libnotify to a configure option
	G2CONF="${G2CONF} $(use_enable ipv6) $(use_enable esd) $(use_enable tcpd tcp-wrappers)"
}

src_unpack() {
	gnome2_src_unpack

	# Patch for Gentoo Branding (bug #42687)
	use branding && epatch "${FILESDIR}/${PN}-2.17.90.1-gentoo-branding.patch"

	# Get rid of random asserts in tons of programs due to development versions
	epatch "${FILESDIR}/${PN}-2.19.2-no-asserts.patch"
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
