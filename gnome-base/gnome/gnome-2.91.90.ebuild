# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.32.1.ebuild,v 1.7 2011/03/11 18:47:45 pacho Exp $

EAPI="3"

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="cdr cups dvdr" # accessibility

S=${WORKDIR}

# TODO: check a11y and re-enable USE-flag
RDEPEND="
	>=dev-libs/glib-2.28.3:2
	>=media-libs/clutter-1.6.10:1.0
	>=x11-libs/gtk+-3.0.4:3[cups?]
	>=x11-libs/gdk-pixbuf-2.23.1:2
	>=dev-libs/atk-1.33.6
	>=x11-libs/pango-1.28.3
	>=x11-libs/libwnck-${PV}:3
	>=gnome-base/librsvg-2.32.1[gtk]
	>=gnome-base/gnome-desktop-${PV}:3
	>=gnome-base/libgnomekbd-${PV}
	>=x11-libs/startup-notification-0.10

	>=media-libs/gstreamer-0.10.32:0.10
	>=media-libs/gst-plugins-base-0.10.32:0.10
	>=media-libs/gst-plugins-good-0.10.23:0.10

	>=gnome-base/gdm-${PV}
	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-extra/bug-buddy-2.32.0:2

	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}

	>=x11-wm/metacity-2.30.3-r1
	>=gnome-base/gnome-panel-${PV}
	>=gnome-base/gnome-menus-${PV}

	>=gnome-base/gnome-control-center-${PV}[cups?]
	>=gnome-extra/gnome-screensaver-${PV}
	>=gnome-extra/gnome-power-manager-${PV}
	>=gnome-base/gnome-keyring-${PV}
	>=gnome-base/libgnome-keyring-${PV}

	>=gnome-base/gvfs-1.7
	>=gnome-base/nautilus-${PV}

	>=app-arch/file-roller-${PV}
	>=app-crypt/seahorse-${PV}
	>=app-editors/gedit-2.91.10
	>=app-text/evince-${PV}
	>=gnome-extra/gcalctool-5.91.90
	>=gnome-extra/gconf-editor-${PV}
	>=gnome-extra/gnome-games-${PV}
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-utils-${PV}
	>=gnome-extra/gucharmap-2.32.1
	>=media-gfx/eog-${PV}
	>=media-sound/sound-juicer-2.32.0
	>=media-video/cheese-${PV}
	>=media-video/totem-${PV}
	>=net-analyzer/gnome-nettool-2.91.5
	>=net-misc/vinagre-${PV}
	>=net-misc/vino-2.99.4
	>=www-client/epiphany-${PV}
	>=x11-terms/gnome-terminal-2.33.1

	>=mail-client/evolution-${PV}
	>=gnome-extra/evolution-data-server-${PV}

	>=x11-themes/gtk-engines-2.20.2:2
	>=x11-themes/gnome-backgrounds-2.32.0
	>=x11-themes/gnome-icon-theme-${PV}
	>=x11-themes/gnome-icon-theme-symbolic-${PV}
	>=x11-themes/gnome-themes-standard-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-${PV}
	>=gnome-extra/zenity-${PV}

	cdr? ( >=app-cdr/brasero-${PV} )
	dvdr? ( >=app-cdr/brasero-${PV} )"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.6.6[gdu]"
# Broken from assumptions of gnome-vfs headers being included in nautilus headers,
# which isn't the case with nautilus-2.22, bug #216019
#	>=app-admin/gnome-system-tools-2.32.0
#	>=app-admin/system-tools-backends-2.8

# gnome-cups-manager isn't needed, printing support is in gnome-control-center

# Don't work at all:
#   cheese-2.91.91.1
#   gucharmap-2.33.2
#
# Not ported:
#   bug-buddy-2.32
#   sound-juicer-2.32
#
# Not ported, don't build:
#	gnome-base/gnome-applets (still a part of the moduleset or not?)
#	gnome-extra/evolution-webcal-2.32.0

# These don't work with gsettings/dconf
#	>=app-admin/pessulus-2.30.4
#	ldap? (	>=app-admin/sabayon-2.30.1 )

# I'm not sure what all is in a11y for GNOME 3 yet ~nirbheek
#	accessibility? (
#		>=gnome-extra/libgail-gnome-1.20.3
#		>=gnome-extra/at-spi-1.32.0:1
#		>=app-accessibility/dasher-4.11
#		>=app-accessibility/gnome-mag-0.16.3:1
#		>=app-accessibility/gnome-speech-0.4.25:1
#		>=app-accessibility/gok-2.30.1:1
#		>=app-accessibility/orca-2.32.1
#		>=gnome-extra/mousetweaks-2.32.1 )

# Useless with GNOME Shell
#	>=gnome-extra/deskbar-applet-2.32.0
#	>=gnome-extra/hamster-applet-2.32.1

# Development tools
#   scrollkeeper
#   pkgconfig
#   intltool
#   gtk-doc
#   gnome-doc-utils

pkg_postinst() {
# gnome-wm is gone, session files are now used by gnome-session to decide which
# windowmanager etc to use. Need to document this

	elog "The main file alteration monitoring functionality is"
	elog "provided by >=glib-2.16. Note that on a modern Linux system"
	elog "you do not need the USE=fam flag on it if you have inotify"
	elog "support in your linux kernel ( >=2.6.13 ) enabled."
	elog "USE=fam on glib is however useful for other situations,"
	elog "such as Gentoo/FreeBSD systems. A global USE=fam can also"
	elog "be useful for other packages that do not use the new file"
	elog "monitoring API yet that the new glib provides."
	elog
}
