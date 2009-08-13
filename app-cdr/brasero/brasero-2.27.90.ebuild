# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-2.26.3.ebuild,v 1.1 2009/07/07 16:48:15 mrpouet Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2 eutils

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://www.gnome.org/projects/brasero"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="beagle +cdr +libburn +totem +nautilus"

RDEPEND=">=dev-libs/glib-2.16.5
	>=x11-libs/gtk+-2.16.0
	>=media-libs/gstreamer-0.10.15
	>=media-libs/gst-plugins-base-0.10.15
	>=media-plugins/gst-plugins-ffmpeg-0.10
	>=dev-libs/libxml2-2.6
	>=dev-libs/libunique-1.0.0
	gnome-base/gvfs
	>=app-cdr/cdrdao-1.2.2-r3
	media-libs/libdvdcss
	>=app-cdr/dvd+rw-tools-7.1
	cdr? ( virtual/cdrtools )
	totem? ( >=dev-libs/totem-pl-parser-2.20 )
	beagle? ( >=dev-libs/libbeagle-0.3.0 )
	libburn? ( >=dev-libs/libburn-0.6.0
		>=dev-libs/libisofs-0.6.12 )
	nautilus? ( >=gnome-base/nautilus-2.24.2 )"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	gnome-base/gconf"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-caches
		--disable-dependency-tracking
		$(use_enable cdr cdrtools)
		$(use_enable cdr cdrkit)
		$(use_enable nautilus)
		$(use_enable totem playlist)
		$(use_enable beagle search)
		$(use_enable libburn libburnia)"

	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_prepare() {
	gnome2_src_prepare

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}

src_test() {
	BLING=$LINGUAS
	unset LINGUAS
	emake check || die "emake check failed"
	export LINGUAS=$BLING
	unset BLING
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Brasero can use all audio files handled by the local Gstreamer installation"
	if ! use cdr && ! use libburn; then
		elog
		ewarn "You have disabled all burning backends for Brasero"
		ewarn "Brasero can now do nothing at all. Probably not what you want."
	fi
}
