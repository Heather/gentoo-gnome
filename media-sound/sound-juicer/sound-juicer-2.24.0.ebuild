# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sound-juicer/sound-juicer-2.22.0-r1.ebuild,v 1.1 2008/07/31 21:23:45 eva Exp $

EAPI="1"

inherit eutils gnome2

DESCRIPTION="CD ripper for GNOME 2"
HOMEPAGE="http://www.burtonini.com/blog/computers/sound-juicer/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.16
	>=gnome-extra/nautilus-cd-burner-2.15.3
	>=x11-libs/gtk+-2.12
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2.13
	dev-libs/dbus-glib
	>=media-libs/gstreamer-0.10.5
	>=gnome-extra/gnome-media-2.11.91
	>=media-libs/musicbrainz-2.1.3:1
	>=dev-libs/libcdio-0.70
	media-libs/taglib
	>=media-libs/gst-plugins-base-0.10
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-gio-0.10
	|| (
		>=media-plugins/gst-plugins-cdparanoia-0.10
		>=media-plugins/gst-plugins-cdio-0.10
	)

	>=media-plugins/gst-plugins-meta-0.10-r2:0.10"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	>=app-text/scrollkeeper-0.3.5
	  app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

# needed to get around some sandboxing checks
export GST_INSPECT=/bin/true

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper"
}

pkg_postinst() {
	gnome2_pkg_postinst
	ewarn
	ewarn "If ${PN} does not rip to some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}
