# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-light/gnome-light-2.32.1.ebuild,v 1.4 2011/02/24 18:58:57 tomka Exp $

EAPI="4"

DESCRIPTION="Meta package for GNOME-Light, merge this package to install"
HOMEPAGE="http://www.gnome.org/"
LICENSE="as-is"
SLOT="2.0"
IUSE="cups +fallback +shell"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

# XXX: Note to developers:
# This is a wrapper for the 'light' GNOME 3 desktop, and should only consist of
# the bare minimum of libs/apps needed. It is basically gnome-base/gnome without
# any apps, but shouldn't be used by users unless they know what they are doing.
RDEPEND="!gnome-base/gnome
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-${PV}
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]

	>=gnome-base/nautilus-${PV}

	shell? (
		>=x11-wm/mutter-${PV}
		>=gnome-base/gnome-shell-${PV} )

	fallback? ( >=gnome-base/gnome-fallback-${PV} )

	>=x11-themes/gnome-icon-theme-${PV}
	>=x11-themes/gnome-icon-theme-symbolic-${PV}
	>=x11-themes/gnome-themes-standard-${PV}

	>=x11-terms/gnome-terminal-${PV}
"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.10.0"
S=${WORKDIR}

pkg_pretend() {
	if ! use fallback && ! use shell; then
		# Users probably want to use e16, sawfish, etc
		ewarn "You're installing neither GNOME Shell nor GNOME Fallback!"
		ewarn "You will have to install and manage a window manager by yourself"
		# https://bugs.gentoo.org/show_bug.cgi?id=303375
		ewarn "See: <add link to docs about component handling in gnome-session>"
	fi
}
