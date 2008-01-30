# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/control-center/control-center-2.20.1.ebuild,v 1.1 2007/10/17 21:03:56 eva Exp $

EAPI="1"

inherit eutils gnome2 autotools

DESCRIPTION="The gnome2 Desktop configuration tool"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/sources/gnome-${PN}/${PVP[0]}.${PVP[1]}/gnome-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="alsa eds esd hal"

RDEPEND=">=virtual/xft-2.1.2
		 >=x11-libs/gtk+-2.11.6
		 >=dev-libs/glib-2.13.0
		 >=gnome-base/gconf-2.0
		 >=gnome-base/libglade-2
		 >=gnome-base/librsvg-2.0
		 >=gnome-base/nautilus-2.6
		 >=media-libs/fontconfig-1
		 >=dev-libs/dbus-glib-0.73
		 >=gnome-base/gnome-vfs-2.2
		 >=x11-libs/libxklavier-3.3
		 >=x11-wm/metacity-2.8.6-r1
		 >=gnome-base/gnome-panel-2.0
		 >=gnome-base/libgnomekbd-2.21.4.1
		 >=gnome-base/gnome-desktop-2.2
		 >=gnome-base/gnome-menus-2.11.1
		 >=gnome-base/gnome-settings-daemon-${PV}

		>=media-libs/gstreamer-0.10.1.2
		>=media-libs/gst-plugins-base-0.10.1.2
		>=media-plugins/gst-plugins-gconf-0.10
		media-plugins/gst-plugins-meta:0.10

		   x11-libs/pango
		   dev-libs/libxml2
		   media-libs/freetype

		!arm? ( alsa? ( >=media-libs/alsa-lib-0.9.0 ) )
		eds? ( >=gnome-extra/evolution-data-server-1.7.90 )
		esd? ( >=media-sound/esound-0.2.28 )
		hal? ( >=sys-apps/hal-0.5.6 )

		 >=gnome-base/libbonobo-2
		 >=gnome-base/libgnome-2.2
		 >=gnome-base/libbonoboui-2
		 >=gnome-base/libgnomeui-2.2

		   x11-apps/xmodmap
		   x11-libs/libXScrnSaver
		   x11-libs/libXext
		   x11-libs/libX11
		   x11-libs/libXxf86misc
		   x11-libs/libXi
		   x11-libs/libXrandr
		   x11-libs/libXrender
		   x11-libs/libXcursor"
DEPEND="${RDEPEND}
		  x11-proto/scrnsaverproto
		  x11-proto/xextproto
		  x11-proto/xproto
		  x11-proto/xf86miscproto
		  x11-proto/kbproto
		  x11-proto/inputproto
		  x11-proto/randrproto
		  x11-proto/renderproto

		  sys-devel/gettext
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19
		  dev-util/desktop-file-utils
		
		  app-text/scrollkeeper
		  gnome-base/gnome-common
		>=app-text/gnome-doc-utils-0.10.1"

DOCS="AUTHORS ChangeLog NEWS README TODO"
S="${WORKDIR}/gnome-${P}"

pkg_setup() {
	G2CONF="${G2CONF} --disable-update-mimedb \
			--enable-vfs-methods              \
			--enable-gstreamer=0.10           \
			$(use_enable alsa)                \
			$(use_enable eds aboutme)         \
			$(use_enable esd)                 \
			$(use_enable hal)"
}

src_unpack() {
	gnome2_src_unpack

	# Allow building with scrollkeeper
	epatch "${FILESDIR}/${PN}-2.18.1-gnome-doc-utils-fix.patch"

	# Drop esound unless requested
	use esd || epatch "${FILESDIR}/${PN}-2.19.90-no-esd.patch"

	eautoreconf
}
