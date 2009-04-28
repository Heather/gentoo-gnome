# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.24.1.ebuild,v 1.6 2009/03/19 16:01:44 josejx Exp $
EAPI="1"

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

IUSE="accessibility cdr cups dvdr esd ldap mono"

S=${WORKDIR}

RDEPEND="
	>=dev-libs/glib-2.20.0
	>=x11-libs/gtk+-2.16.0
	>=dev-libs/atk-1.26.0
	>=x11-libs/pango-1.24.0

	>=dev-libs/libxml2-2.7.2
	>=dev-libs/libxslt-1.1.22

	>=media-libs/audiofile-0.2.6-r1
	esd? ( >=media-sound/esound-0.2.41 )
	>=x11-libs/libxklavier-3.6
	>=media-libs/libart_lgpl-2.3.20

	>=dev-libs/libIDL-0.8.13
	>=gnome-base/orbit-2.14.16

	>=x11-libs/libwnck-2.26.0
	>=x11-wm/metacity-2.26.0

	>=gnome-base/gnome-keyring-2.26.0
	>=app-crypt/seahorse-2.26.0

	>=gnome-base/gnome-vfs-2.24.1

	>=gnome-base/gnome-mime-data-2.18.0

	>=gnome-base/gconf-2.26.0
	>=net-libs/libsoup-2.26.0

	>=gnome-base/libbonobo-2.24.1
	>=gnome-base/libbonoboui-2.24.1
	>=gnome-base/libgnome-2.26.0
	>=gnome-base/libgnomeui-2.24.1
	>=gnome-base/libgnomecanvas-2.26.0
	>=gnome-base/libglade-2.6.4

	>=gnome-extra/bug-buddy-2.26.0
	>=gnome-base/libgnomekbd-2.26.0
	>=gnome-base/gnome-settings-daemon-2.25.92
	>=gnome-base/gnome-control-center-2.26.0

	>=gnome-base/gvfs-1.2.0
	>=gnome-base/eel-2.24.0
	>=gnome-base/nautilus-2.26.0

	>=media-libs/gstreamer-0.10.22
	>=media-libs/gst-plugins-base-0.10.22
	>=media-libs/gst-plugins-good-0.10.14
	>=gnome-extra/gnome-media-2.26.0
	>=media-sound/sound-juicer-2.26.0
	>=dev-libs/totem-pl-parser-2.26.0
	>=media-video/totem-2.26.0

	>=media-gfx/eog-2.26.0

	>=www-client/epiphany-2.26.0
	>=app-arch/file-roller-2.26.0
	>=gnome-extra/gcalctool-5.26.0

	>=gnome-extra/gconf-editor-2.26.0
	>=gnome-base/gdm-2.26.0
	>=x11-libs/gtksourceview-2.6.0:2.0
	>=app-editors/gedit-2.26.0

	>=app-text/evince-2.26.0

	>=gnome-base/gnome-desktop-2.26.0
	>=gnome-base/gnome-session-2.26.0
	>=dev-libs/libgweather-2.26.0
	>=gnome-base/gnome-applets-2.26.0
	>=gnome-base/gnome-panel-2.26.0
	>=gnome-base/gnome-menus-2.26.0
	>=x11-themes/gnome-icon-theme-2.26.0
	>=x11-themes/gnome-themes-2.26.0
	>=gnome-extra/deskbar-applet-2.26.0

	>=x11-themes/gtk-engines-2.18.0
	>=x11-themes/gnome-backgrounds-2.24.1

	>=x11-libs/vte-0.20.0
	>=x11-terms/gnome-terminal-2.26.0

	>=gnome-extra/gucharmap-2.26.0
	>=gnome-base/libgnomeprint-2.18.6
	>=gnome-base/libgnomeprintui-2.18.4

	>=gnome-extra/gnome-utils-2.26.0

	>=dev-python/gnome-python-desktop-2.26.0
	>=gnome-extra/gnome-games-2.26.0
	>=gnome-base/librsvg-2.26.0

	>=gnome-extra/gnome-system-monitor-2.26.0.1
	>=gnome-base/libgtop-2.26.0

	>=x11-libs/startup-notification-0.9

	>=gnome-extra/gnome-user-docs-2.26.0
	>=gnome-extra/yelp-2.26.0
	>=gnome-extra/zenity-2.26.0

	>=net-analyzer/gnome-netstatus-2.26.0
	>=net-analyzer/gnome-nettool-2.26.0

	cdr? (
		|| (
			>=app-cdr/brasero-2.26.0
			>=gnome-extra/nautilus-cd-burner-2.24.0 ) )
	dvdr? (
		|| (
			>=app-cdr/brasero-2.26.0
			>=gnome-extra/nautilus-cd-burner-2.24.0 ) )

	>=gnome-extra/gtkhtml-3.26.0
	>=mail-client/evolution-2.26.0
	>=gnome-extra/evolution-data-server-2.26.0
	>=gnome-extra/evolution-webcal-2.26.0

	>=net-misc/vino-2.26.0

	>=app-admin/pessulus-2.26.0
	ldap? (
		>=app-admin/sabayon-2.25.0
		>=net-voip/ekiga-2.0.12 )

	>=gnome-extra/gnome-screensaver-2.26.0
	>=x11-misc/alacarte-0.11.10
	>=gnome-extra/gnome-power-manager-2.26.0
	>=gnome-base/gnome-volume-manager-2.24.0

	>=net-misc/vinagre-2.26.0
	>=gnome-extra/swfdec-gnome-2.26.0

	accessibility? (
		>=gnome-extra/libgail-gnome-1.20.1
		>=gnome-extra/at-spi-1.26.0
		>=app-accessibility/dasher-4.10.0
		>=app-accessibility/gnome-mag-0.15.5
		>=app-accessibility/gnome-speech-0.4.25
		>=app-accessibility/gok-2.26.0
		>=app-accessibility/orca-2.26.0
		>=gnome-extra/mousetweaks-2.26.0 )
	cups? ( >=net-print/gnome-cups-manager-0.31-r2 )

	mono? ( >=app-misc/tomboy-0.14.0 )"
# Broken from assumptions of gnome-vfs headers being included in nautilus headers,
# which isn't the case with nautilus-2.22, bug #216019
#	>=app-admin/gnome-system-tools-2.22.2
#	>=app-admin/system-tools-backends-1.4.2

# Development tools
#   scrollkeeper
#   pkgconfig
#   intltool
#   gtk-doc
#   gnome-doc-utils

pkg_postinst() {
# FIXME: Rephrase to teach about using different WMs instead, as metacity is the default anyway
# FIXME: but first check WINDOW_MANAGER is still honored in 2.24. gnome-session-2.24 might have lost
# FIXME: support for it, but we don't ship with gnome-session-2.24 yet
#	elog "Note that to change windowmanager to metacity do: "
#	elog " export WINDOW_MANAGER=\"/usr/bin/metacity\""
#	elog "of course this works for all other window managers as well"

	elog "The main file alteration monitoring functionality is"
	elog "provided by >=glib-2.16. Note that on a modern Linux system"
	elog "you do not need the USE=fam flag on it if you have inotify"
	elog "support in your linux kernel ( >=2.6.13 ) enabled."
	elog "USE=fam on glib is however useful for other situations,"
	elog "such as Gentoo/FreeBSD systems. A global USE=fam can also"
	elog "be useful for other packages that do not use the new file"
	elog "monitoring API yet that the new glib provides."
	elog
	elog
	elog "Add yourself to the plugdev group if you want"
	elog "automounting to work."
	elog
}
