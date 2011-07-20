# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-color-manager/gnome-color-manager-2.32.0.ebuild,v 1.6 2011/03/23 06:10:42 ssuominen Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="Color profile manager for the GNOME desktop"
HOMEPAGE="http://projects.gnome.org/gnome-color-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection packagekit raw scanner"

# FIXME: raise libusb:1 to 1.0.9 when available
# FIXME: fix detection of docbook2man
COMMON_DEPEND=">=dev-libs/glib-2.25.9:2
	>=dev-libs/libusb-1:1
	>=gnome-base/gnome-control-center-3
	gnome-base/gnome-settings-daemon

	media-libs/lcms:2
	>=media-libs/libcanberra-0.10[gtk3]
	media-libs/libexif
	media-libs/tiff
	net-print/cups

	|| ( sys-fs/udev[gudev] sys-fs/udev[extras] )
	x11-libs/libX11
	x11-libs/libXrandr
	>=x11-libs/gtk+-2.91:3
	>=x11-libs/libnotify-0.7
	>=x11-libs/vte-0.25.1:2.90

	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	scanner? ( media-gfx/sane-backends )
	packagekit? ( app-admin/packagekit-base )
	raw? ( media-gfx/exiv2 )
"
RDEPEND="${RDEPEND}
	media-gfx/shared-color-profiles
"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
DEPEND="${RDEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	app-text/gnome-doc-utils
	dev-libs/libxslt
	>=dev-util/intltool-0.35
"

# FIXME: run test-suite with files on live file-system
RESTRICT="test"

pkg_setup() {
	# Always enable tests since they are check_PROGRAMS anyway
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		--disable-scrollkeeper
		--enable-tests
		$(use_enable packagekit)
		$(use_enable introspection)
		$(use_enable raw exiv)
		$(use_enable scanner sane)"
}

src_prepare() {
	# Fix build
	epatch "${FILESDIR}/${P}-packagename.patch"

	# Upstream renamed 95-gcm-colorimeters.rules to 69-gcm-colorimeters.rules
	# for next release (see commit dc276cbe) to fix colorimeter udev ACLs.
	mv -f rules/{95,69}-gcm-colorimeters.rules || die "mv failed"
	sed -e 's:95-gcm-colorimeters.rules:69-gcm-colorimeters.rules:' \
		-i rules/Makefile.* || die "sed rules/Makefile.* failed"

	# Upstream patch to fix a bug in control center panel when plugging in a
	# colorimeter; will be in next release
	epatch "${FILESDIR}/${P}-cc-panel.patch"

	gnome2_src_prepare
}
