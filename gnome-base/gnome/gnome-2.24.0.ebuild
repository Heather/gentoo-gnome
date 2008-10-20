# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.22.3.ebuild,v 1.5 2008/09/11 16:36:09 jer Exp $
EAPI="1"

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="accessibility cdr cups dvdr esd ldap mono"

S=${WORKDIR}

RDEPEND="
	>=dev-libs/glib-2.18.1
	>=x11-libs/gtk+-2.14.3
	>=dev-libs/atk-1.24.0
	>=x11-libs/pango-1.21.6

	>=dev-libs/libxml2-2.6.31
	>=dev-libs/libxslt-1.1.22

	>=media-libs/audiofile-0.2.6-r1
	esd? ( >=media-sound/esound-0.2.40 )
	>=x11-libs/libxklavier-3.3
	>=media-libs/libart_lgpl-2.3.20

	>=dev-libs/libIDL-0.8.11
	>=gnome-base/orbit-2.14.16

	>=x11-libs/libwnck-2.24.0
	>=x11-wm/metacity-2.24.0

	>=gnome-base/gnome-keyring-2.24.0
	>=app-crypt/seahorse-2.24.0
	>=app-crypt/seahorse-plugins-2.24.0

	>=gnome-base/gnome-vfs-2.24.0

	>=gnome-base/gnome-mime-data-2.18.0

	>=gnome-base/gconf-2.24.0
	>=net-libs/libsoup-2.24.0.1

	>=gnome-base/libbonobo-2.24.0
	>=gnome-base/libbonoboui-2.24.0
	>=gnome-base/libgnome-2.24.1
	>=gnome-base/libgnomeui-2.24.0
	>=gnome-base/libgnomecanvas-2.20.1.1
	>=gnome-base/libglade-2.6.3

	>=gnome-extra/bug-buddy-2.24.0
	>=gnome-base/libgnomekbd-2.24.0
	>=gnome-base/gnome-settings-daemon-2.24.0
	>=gnome-base/gnome-control-center-2.24.0.1

	>=gnome-base/gvfs-1.0.1
	>=gnome-base/eel-2.24.0
	>=gnome-base/nautilus-2.24.0

	>=media-libs/gstreamer-0.10.20
	>=media-libs/gst-plugins-base-0.10.20
	>=media-libs/gst-plugins-good-0.10.8
	>=gnome-extra/gnome-media-2.24.0.1
	>=media-sound/sound-juicer-2.24.0
	>=dev-libs/totem-pl-parser-2.24.0
	>=media-video/totem-2.24.0

	>=media-gfx/eog-2.24.0

	>=www-client/epiphany-2.24.0.1
	>=app-arch/file-roller-2.24.0
	>=gnome-extra/gcalctool-5.24.0

	>=gnome-extra/gconf-editor-2.24.0.1
	>=x11-libs/gtksourceview-2.4.0:2.0
	>=app-editors/gedit-2.24.0

	>=app-text/evince-2.24.0

	>=gnome-base/gnome-desktop-2.24.0
	>=gnome-base/gnome-session-2.24.0
	>=dev-libs/libgweather-2.24.0
	>=gnome-base/gnome-applets-2.24.0.1
	>=gnome-base/gnome-panel-2.24.0
	>=gnome-base/gnome-menus-2.24.0
	>=x11-themes/gnome-icon-theme-2.24.0
	>=x11-themes/gnome-themes-2.24.0
	>=gnome-extra/deskbar-applet-2.24.0
	>=gnome-extra/hamster-applet-2.24.0

	>=x11-themes/gtk-engines-2.16.0
	>=x11-themes/gnome-backgrounds-2.24.0

	>=x11-libs/vte-0.17.4
	>=x11-terms/gnome-terminal-2.24.0

	>=gnome-extra/gucharmap-2.24.0
	>=gnome-base/libgnomeprint-2.18.5
	>=gnome-base/libgnomeprintui-2.18.3

	>=gnome-extra/gnome-utils-2.24.0

	>=dev-python/gnome-python-desktop-2.22.0
	>=gnome-extra/gnome-games-2.24.0
	>=gnome-base/librsvg-2.22.3

	>=gnome-extra/gnome-system-monitor-2.24.0
	>=gnome-base/libgtop-2.24.0

	>=x11-libs/startup-notification-0.9

	>=gnome-extra/gnome-user-docs-2.24.0
	>=gnome-extra/yelp-2.24.0
	>=gnome-extra/zenity-2.24.0

	>=net-analyzer/gnome-netstatus-2.12.1
	>=net-analyzer/gnome-nettool-2.22.1

	cdr? ( >=gnome-extra/nautilus-cd-burner-2.24.0 )
	dvdr? ( >=gnome-extra/nautilus-cd-burner-2.24.0 )

	>=gnome-extra/gtkhtml-3.24.0
	>=mail-client/evolution-2.24.0
	>=gnome-extra/evolution-data-server-2.24.0
	>=gnome-extra/evolution-webcal-2.24.0

	|| (
		>=gnome-base/gdm-2.20.8
		>=gnome-extra/fast-user-switch-applet-2.22.0 )

	>=app-admin/pessulus-2.24.0
	ldap? (
		>=app-admin/sabayon-2.22.1
		>=net-im/ekiga-2.0.12
		)

	>=gnome-extra/gnome-screensaver-2.24.0
	>=x11-misc/alacarte-0.11.6
	!ppc64? ( >=gnome-extra/gnome-power-manager-2.24.0 )
	>=gnome-base/gnome-volume-manager-2.24.0

	>=net-misc/vino-2.24.0
	>=net-misc/vinagre-2.24.0

	>=gnome-extra/swfdec-gnome-2.24.0
	>=net-im/empathy-2.24.0

	accessibility? (
		>=gnome-extra/libgail-gnome-1.20.1
		>=gnome-base/gail-1.22.3
		>=gnome-extra/at-spi-1.24.0
		>=app-accessibility/dasher-4.9.0
		>=app-accessibility/gnome-mag-0.15.4
		>=app-accessibility/gnome-speech-0.4.21
		>=app-accessibility/gok-2.24.0
		>=app-accessibility/orca-2.24.0
		>=gnome-extra/mousetweaks-2.24.0
		>=app-accessibility/accerciser-1.4.0 )
	cups? ( >=net-print/gnome-cups-manager-0.31-r2 )

	mono? ( >=app-misc/tomboy-0.11.2 )"
# Broken from assumptions of gnome-vfs headers being included in nautilus headers,
# which isn't the case with nautilus-2.22, bug #216019
#	>=app-admin/gnome-system-tools-2.22.1
#	>=app-admin/system-tools-backends-1.4.2

# Development tools
#   scrollkeeper
#   pkgconfig
#   intltool
#   gtk-doc
#   gnome-doc-utils

pkg_postinst() {

	elog "Note that to change windowmanager to metacity do: "
	elog " export WINDOW_MANAGER=\"/usr/bin/metacity\""
	elog "of course this works for all other window managers as well"
	elog
	elog "The main file alteration monitoring functionality is now"
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
