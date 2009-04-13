# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet debug epiphany gedit libnotify nautilus test"

RDEPEND="
	>=gnome-base/libglade-2.0
	>=gnome-base/gconf-2.0
	>=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.72
	>=app-crypt/gpgme-1.0.0
	>=app-crypt/seahorse-2.25
	>=gnome-base/gnome-keyring-2.25
	>=gnome-extra/evolution-data-server-1.8

	|| (
		=app-crypt/gnupg-1.4*
		=app-crypt/gnupg-2.0* )

	nautilus? ( >=gnome-base/nautilus-2.12 )
	epiphany? (
		>=www-client/epiphany-2.24
		>=dev-libs/libxml2-2.6.0 )
	gedit? ( >=app-editors/gedit-2.16 )
	applet? ( >=gnome-base/gnome-panel-2.10 )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=app-text/gnome-doc-utils-0.3.2
		>=app-text/scrollkeeper-0.3
		>=dev-util/pkgconfig-0.20
		>=dev-util/intltool-0.35"

pkg_setup() {
	if use epiphany ; then
		if has_version '>=www-client/epiphany-2.24.3-r10'; then
			G2CONF="${G2CONF} --with-gecko=libxul-unstable"
		else
			# Now, epiphany could be using xul-1.8, xul-1.9 or ff-2
			# Let it auto-detect.
			:
		fi
	fi

	G2CONF="${G2CONF}
		--enable-agent
		--disable-update-mime-database
		$(use_enable applet)
		$(use_enable debug)
		$(use_enable epiphany)
		$(use_enable gedit)
		$(use_enable libnotify)
		$(use_enable nautilus)
		$(use_enable test tests)"
}

src_install() {
	gnome2_src_install

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/70-seahorse-agent" || die "doexe failed"
}
