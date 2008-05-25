# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-volume-manager/gnome-volume-manager-2.22.1.ebuild,v 1.2 2008/05/14 16:34:02 corsair Exp $

inherit gnome2 eutils

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sh ~sparc ~x86" # ~x86-fbsd"
IUSE="debug"

# TODO: libnotify support is optional but doesn't have a configure switch

RDEPEND=">=gnome-base/libgnomeui-2.1.5
	>=dev-libs/dbus-glib-0.71
	>=sys-apps/hal-0.5.9
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2
	>=x11-libs/libnotify-0.3
	>=gnome-base/gconf-2

	  gnome-base/nautilus
	>=gnome-base/gnome-mount-0.6"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog README HACKING NEWS TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable debug)"

	# FIXME: We should be more intelligent about disabling multiuser support
	# (like enable it when pam_console is available?). For now, this is a
	# slightly nicer solution than applying ${PN}-1.5.9-no-pam_console.patch
	# FIXME: now that we have pambase, find time to check if we can do this
	G2CONF="${G2CONF} --disable-multiuser"
}

src_unpack() {
	gnome2_src_unpack

	# Fix most FreeBSD issues (bug #183442) -- local fallback wont work
	epatch "${FILESDIR}"/${PN}-2.22.0-fbsd-support.patch

	# Fix default totem command.  Bug #200999
	epatch "${FILESDIR}"/${PN}-2.17.0-totem-dvd.patch
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To start the gnome-volume-manager daemon you need to configure"
	elog "it through it's preferences capplet. Also the HAL daemon (hald)"
	elog "needs to be running or it will shut down."
}
