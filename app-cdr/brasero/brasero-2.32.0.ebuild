# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-2.30.1.ebuild,v 1.1 2010/06/13 19:25:35 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit eutils gnome2 multilib

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://www.gnome.org/projects/brasero"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="beagle +cdr +css doc gtk3 +introspection +libburn nautilus playlist test"

COMMON_DEPEND=">=dev-libs/glib-2.25.10
	gtk3? (
		media-libs/libcanberra[gtk3]
		>=x11-libs/gtk+-2.90.7:3[introspection?] )
	!gtk3? (
		media-libs/libcanberra[gtk]
		>=x11-libs/gtk+-2.21.9:2[introspection?] )
	>=gnome-base/gconf-2.31.1
	>=media-libs/gstreamer-0.10.15
	>=media-libs/gst-plugins-base-0.10
	>=dev-libs/libxml2-2.6
	>=dev-libs/libunique-1
	x11-libs/libSM
	beagle? ( >=dev-libs/libbeagle-0.3 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )
	libburn? (
		>=dev-libs/libburn-0.4
		>=dev-libs/libisofs-0.6.4 )
	nautilus? ( >=gnome-base/nautilus-2.31.3[introspection?] )
	playlist? ( >=dev-libs/totem-pl-parser-2.29.1 )"
RDEPEND="${COMMON_DEPEND}
	app-cdr/cdrdao
	app-cdr/dvd+rw-tools
	media-plugins/gst-plugins-meta
	css? ( media-libs/libdvdcss )
	cdr? ( virtual/cdrtools )
	!libburn? ( virtual/cdrtools )"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	doc? ( >=dev-util/gtk-doc-1.12 )
	test? ( app-text/docbook-xml-dtd:4.3 )"
# eautoreconf deps
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am
PDEPEND="gnome-base/gvfs"

pkg_setup() {
	if use gtk3; then
		G2CONF="${G2CONF} --with-gtk=3.0"
	else
		G2CONF="${G2CONF} --with-gtk=2.0"
	fi

	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-caches
		--disable-dependency-tracking
		$(use_enable beagle search beagle)
		$(use_enable cdr cdrtools)
		$(use_enable cdr cdrkit)
		$(use_enable introspection)
		$(use_enable libburn libburnia)
		$(use_enable nautilus)
		$(use_enable playlist)"

	if ! use libburn; then
		G2CONF="${G2CONF} --enable-cdrtools --enable-cdrkit"
	fi

	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_install() {
	gnome2_src_install

	# Remove useless .la files
	rm -f "${ED}"/usr/$(get_libdir)/brasero/plugins/*.la
	rm -f "${ED}"/usr/$(get_libdir)/nautilus/extensions-2.0/*.la
}


pkg_preinst() {
	gnome2_pkg_preinst

	preserve_old_lib_notify /usr/$(get_libdir)/libbrasero-burn.so.0
	preserve_old_lib_notify /usr/$(get_libdir)/libbrasero-media.so.0
	preserve_old_lib_notify /usr/$(get_libdir)/libbrasero-utils.so.0
}

pkg_postinst() {
	gnome2_pkg_postinst

	preserve_old_lib /usr/$(get_libdir)/libbrasero-burn.so.0
	preserve_old_lib /usr/$(get_libdir)/libbrasero-media.so.0
	preserve_old_lib /usr/$(get_libdir)/libbrasero-utils.so.0

	echo
	elog "If ${PN} doesn't handle some music or video format, please check"
	elog "your USE flags on media-plugins/gst-plugins-meta"
}
