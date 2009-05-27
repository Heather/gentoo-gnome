# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tracker/tracker-0.6.6-r1.ebuild,v 1.9 2009/01/10 16:36:39 maekke Exp $

EAPI="2"

inherit eutils flag-o-matic gnome2 linux-info

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="http://www.tracker-project.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="applet debug deskbar eds exif gnome gsf gstreamer gtk hal +jpeg pdf xine kernel_linux +tiff vorbis xml xmp"

# Automagic, gconf, raptor
RDEPEND=">=dev-libs/dbus-glib-0.71
	>=dev-libs/glib-2.16.0
	>=x11-libs/pango-1.0.0
	>=dev-db/qdbm-1.8
	=dev-libs/gmime-2.2*
	xml? ( >=dev-libs/libxml2-2.6 )

	>=gnome-base/gconf-2
	media-libs/raptor

	>=media-libs/libpng-1.2
	>=dev-db/sqlite-3.5[threadsafe]
	>=media-gfx/imagemagick-5.2.1[png,jpeg=]
	applet? ( >=x11-libs/libnotify-0.4.3
		>=x11-libs/gtk+-2.16 )
	deskbar? ( >=gnome-extra/deskbar-applet-2.19 )
	gnome? (
		>=x11-libs/gtk+-2.16
		>=gnome-base/libgnome-2.14
		>=gnome-base/libgnomeui-2.14
		>=gnome-base/gnome-vfs-2.10
		>=gnome-base/gnome-desktop-2.14
		>=gnome-base/libglade-2.5 )
	gsf? ( >=gnome-extra/libgsf-1.13 )

	dev-libs/totem-pl-parser

	gstreamer? ( >=media-libs/gstreamer-0.10 )
	!gstreamer? ( !xine? ( || ( media-video/totem media-video/mplayer ) ) )
	xine? ( >=media-libs/xine-lib-1.0 )

	gtk? ( >=x11-libs/gtk+-2.16.0 )
	hal? ( >=sys-apps/hal-0.5 )
	!kernel_linux? ( >=app-admin/gamin-0.1.7 )
	pdf? (
		>=x11-libs/cairo-1.0
		>=virtual/poppler-glib-0.5[cairo]
		>=virtual/poppler-utils-0.5 )
	eds? (
		>=mail-client/evolution-2.25.5
		>=gnome-extra/evolution-data-server-2.25.5 )
	exif? ( >=media-libs/libexif-0.6 )
	jpeg? ( media-libs/jpeg )
	tiff? ( media-libs/tiff )
	vorbis? ( media-libs/libvorbis )
	xmp? ( >=media-libs/exempi-2 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.14
	>=dev-util/pkgconfig-0.20
	doc? ( >=dev-util/gtk-doc-1.8 )"

DOCS="AUTHORS ChangeLog NEWS README"

function notify_inotify() {
	ewarn
	ewarn "You should enable the INOTIFY support in your kernel."
	ewarn "Check the 'Inotify file change notification support' under the"
	ewarn "'File systems' option.  It is marked as CONFIG_INOTIFY in the config"
	ewarn "Also enable 'Inotify support for userland' in under the previous"
	ewarn "option.  It is marked as CONFIG_INOTIFY_USER in the config."
	ewarn
	die 'missing CONFIG_INOTIFY'
}

function inotify_enabled() {
	linux_chkconfig_present INOTIFY && linux_chkconfig_present INOTIFY_USER
}

pkg_setup() {
	linux-info_pkg_setup

	if use kernel_linux ; then
		inotify_enabled || notify_inotify
	fi

	if use gstreamer ; then
		G2CONF="${G2CONF} --enable-video-extractor=gstreamer"
	elif use xine ; then
		G2CONF="${G2CONF} --enable-video-extractor=xine"
	else
		G2CONF="${G2CONF} --enable-video-extractor=external"
	fi

	if use kernel_linux ; then
		G2CONF="${G2CONF} --enable-file-monitoring=inotify"
	else
		G2CONF="${G2CONF} --enable-file-monitoring=fam"
	fi

	# doesn't build yet --enable-sqlite-fts
	G2CONF="${G2CONF}
		--enable-external-qdbm
		--disable-unac
		--enable-preferences
		--enable-playlist
		$(use_enable applet trackerapplet)
		$(use_enable deskbar deskbar-applet auto)
		$(use_enable debug debug-code)
		$(use_enable gnome gui)
		$(use_enable gsf libgsf)
		$(use_enable gtk libtrackergtk)
		$(use_enable hal)
		$(use_enable exif libexif)
		$(use_enable pdf)
		$(use_enable xmp exempi)
		$(use_enable eds evolution-push-module)"
}

src_prepare() {
	if use eds ; then
		# Fix compilation error, bug #270931
		epatch "${FILESDIR}/${P}-eds-missing-parameters.patch"
		# Fix missing dbus-binding-tool xml sheets
		epatch "${FILESDIR}/${P}-eds-dbusbindingtool-sheets.patch"
	fi

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}
