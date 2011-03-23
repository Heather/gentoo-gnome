# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-light/gnome-light-2.32.1.ebuild,v 1.4 2011/02/24 18:58:57 tomka Exp $

EAPI="3"

S=${WORKDIR}
DESCRIPTION="Meta package for the GNOME desktop, merge this package to install"
HOMEPAGE="http://www.gnome.org/"
LICENSE="as-is"
SLOT="2.0"
IUSE="+automount"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

# Note to developers:
# This is a wrapper for the 'light' Gnome2 desktop,
# This should only consist of the bare minimum of libs/apps needed
# It is basically gnome-base/gnome without all extra apps
#
# metacity is still needed for fallback mode, that will change later
# XXX: This list is incomplete!
RDEPEND="!gnome-base/gnome

	>=dev-libs/glib-2.28.1:2
	>=media-libs/clutter-1.6.2:1.0
	>=x11-libs/gtk+-3.0.0:3
	>=x11-libs/gdk-pixbuf-2.23.1:2
	>=dev-libs/atk-1.33.6
	>=x11-libs/pango-1.28.3
	>=x11-libs/libwnck-${PV}:3
	>=gnome-base/librsvg-2.32.1[gtk]

	>=gnome-base/gnome-desktop-${PV}:3
	>=gnome-base/gnome-settings-daemon-${PV}
	>=gnome-base/gnome-control-center-${PV}

	>=gnome-base/nautilus-${PV}

	>=gnome-base/gnome-session-${PV}
	
	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}

	>=x11-wm/metacity-2.30.3
	>=gnome-base/gnome-panel-${PV}

	>=x11-themes/gnome-icon-theme-2.91.7
	>=x11-themes/gnome-icon-theme-symbolic-2.91.7
	>=x11-themes/gnome-themes-standard-${PV}

	>=x11-terms/gnome-terminal-2.33.1

	>=gnome-extra/yelp-${PV}"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.7.2"
# Automount is handled by gnome-settings-daemon now.
# Double-check how it's done, and add deps if needed.

# XXX: Uncomment when we have a gnome-base/gnome meta for GNOME 3
#pkg_postinst () {
#	elog "Use gnome-base/gnome for the full GNOME Desktop"
#	elog "as released by the GNOME team."
#}
