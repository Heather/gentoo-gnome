# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-2.32.1.ebuild,v 1.2 2010/12/05 18:40:27 eva Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 multilib
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://projects.gnome.org/brasero/"

LICENSE="GPL-2"
SLOT="0"
IUSE="beagle cdr +css doc +introspection +libburn nautilus packagekit playlist test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

COMMON_DEPEND="
	>=dev-libs/glib-2.27.5:2
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=gnome-base/gconf-2.32.0:2
	>=media-libs/gstreamer-0.10.15:0.10
	>=media-libs/gst-plugins-base-0.10:0.10
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/libnotify-0.6.1

	media-libs/libcanberra[gtk3]
	x11-libs/libICE
	x11-libs/libSM

	beagle? ( >=dev-libs/libbeagle-0.3 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )
	libburn? (
		>=dev-libs/libburn-0.4
		>=dev-libs/libisofs-0.6.4 )
	nautilus? ( >=gnome-base/nautilus-2.91.90 )
	playlist? ( >=dev-libs/totem-pl-parser-2.29.1 )"
RDEPEND="${COMMON_DEPEND}
	app-cdr/cdrdao
	app-cdr/dvd+rw-tools
	media-plugins/gst-plugins-meta
	css? ( media-libs/libdvdcss )
	cdr? ( virtual/cdrtools )
	!libburn? ( virtual/cdrtools )
	packagekit? ( app-portage/packagekit )"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	gnome-base/gnome-common
	>=dev-util/gtk-doc-am-1.12
	doc? ( >=dev-util/gtk-doc-1.12 )
	test? ( app-text/docbook-xml-dtd:4.3 )"
# eautoreconf deps
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am
PDEPEND="gnome-base/gvfs"

pkg_setup() {
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

src_prepare() {
	# Fix linking against installed libraries, bug #340767, gnome #641233
	epatch "${FILESDIR}/${PN}-2.91.6-build-plugins-against-local-library.patch"

	if [[ ${PV} != 9999 ]]; then
		intltoolize --force --copy --automake || die "intltoolize failed"
		eautoreconf
	fi

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst

	echo
	elog "If ${PN} doesn't handle some music or video format, please check"
	elog "your USE flags on media-plugins/gst-plugins-meta"
}
