# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcanberra/libcanberra-0.25.ebuild,v 1.1 2010/06/18 10:11:15 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="GNOME Media Profiles library"
HOMEPAGE="http://git.gnome.org/browse/libgnome-media-profiles"

LICENSE="LGPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

# FIXME: automagic dep on gladeui-3.0
# these guys are just copy-pasting configure code b/w modules with all the bugs
COMMON_DEPEND="
	dev-libs/glib
	>=x11-libs/gtk+-2.91.0:3
	>=media-libs/gstreamer-0.10.23:0.10
	>=media-libs/gst-plugins-base-0.10.23:0.10
	gnome-base/gconf:2"
# NOTE: Audio profile stuff moved from gnome-media to here, so we add a blocker
#       to avoid collisions
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gnome-media-2.32.0-r300"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.19
	sys-devel/gettext"

pkg_setup() {
	DOCS="ChangeLog NEWS README"
	G2CONF="${G2CONF} --disable-static"
}
