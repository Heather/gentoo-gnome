# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-media/gnome-media-2.32.0.ebuild,v 1.1 2010/10/17 18:56:04 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Multimedia tools for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/GnomeMedia"

LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="2"
# Apps that need libgnome-media-profiles.so need gnome-media-2.32, so this
# should not be installed till *everything* that uses that is ported to gtk+:3
KEYWORDS=""
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

# FIXME: configure.ac needs cleaning: g-v-c was removed, but PA checks weren't
RDEPEND="dev-libs/libxml2:2
	>=dev-libs/glib-2.18.2:2
	>=x11-libs/gtk+-2.91.0:3
	>=gnome-base/gconf-2.6.1:2
	>=media-libs/gstreamer-0.10.23:0.10
	>=media-libs/gst-plugins-base-0.10.23:0.10
	>=media-libs/gst-plugins-good-0.10:0.10
	>=media-libs/libcanberra-0.13[gtk3]
	media-libs/libgnome-media-profiles:3
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-gconf-0.10.23:0.10"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/intltool-0.35.0
	sys-devel/gettext"

pkg_setup() {
	# NOTE: gnome-volume-control moved to control-center as a gnome-shell
	#       panel extension
	# NOTE: Profile stuff moved to libgnome-media-profiles
	# FIXME: gstmix will not work with gnome-shell and will clash with g-v-c,
	#        so disable it till we can figure out gnome-shell vs fallback etc.
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-scrollkeeper
		--disable-schemas-install
		--enable-gstprops
		--enable-grecord
		--disable-gstmix"
	DOCS="AUTHORS ChangeLog* NEWS MAINTAINERS README"
}

src_install() {
	gnome2_src_install

	# These files are now provided by gnome-control-center-2.91's sound applet
	# I have no idea when upstream plans to remove these from this tarball
	# -- nirbheek
	rm -v "${ED}"/usr/share/sounds/gnome/default/alerts/*.ogg || die
}

pkg_postinst() {
	gnome2_pkg_postinst
	ewarn
	ewarn "If you cannot play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}
