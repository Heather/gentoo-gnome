# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils gnome2

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="http://www.gnome.org/projects/eog/"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dbus doc exif jpeg lcms python tiff xmp"

RDEPEND=">=x11-libs/gtk+-2.17.5
	>=dev-libs/glib-2.15.3
	>=dev-libs/libxml2-2
	>=gnome-base/gconf-2.5.90
	>=gnome-base/gnome-desktop-2.25.1
	>=x11-themes/gnome-icon-theme-2.19.1
	>=x11-misc/shared-mime-info-0.20

	dbus? ( >=dev-libs/dbus-glib-0.71 )
	exif? (
		>=media-libs/libexif-0.6.14
		media-libs/jpeg )
	jpeg? ( media-libs/jpeg
			x11-libs/gtk+[jpeg] )
	lcms? ( media-libs/lcms )
	python? (
		>=dev-lang/python-2.3
		>=dev-python/pygobject-2.15.1
		>=dev-python/pygtk-2.13 )
	tiff? ( >=x11-libs/gtk+-2.15.1[tiff] )
	xmp? ( >=media-libs/exempi-2 )"

DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1.10 )"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README THANKS TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with exif libjpeg)
		$(use_with exif libexif)
		$(use_with dbus)
		$(use_with lcms cms)
		$(use_enable python)
		$(use_with xmp)
		--disable-scrollkeeper
		--disable-schemas-install"
}
