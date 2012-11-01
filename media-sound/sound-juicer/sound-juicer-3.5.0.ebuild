# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="CD ripper for GNOME"
HOMEPAGE="http://www.burtonini.com/blog/computers/sound-juicer/"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="flac test vorbis"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-2.90:3
	media-libs/libcanberra[gtk3]
	>=app-cdr/brasero-2.90
	>=gnome-base/gconf-2:2
	sys-apps/dbus

	media-libs/libdiscid
	>=media-libs/musicbrainz-5.0.1:5

	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[flac?,vorbis?]
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[cdda,udev]
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0 )
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	>=app-text/scrollkeeper-0.3.5
	app-text/gnome-doc-utils
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	# GST_INSPECT needed to get around some sandboxing checks
	G2CONF="${G2CONF}
		GST_INSPECT=$(type -P true)"
	gnome2_src_configure
}

pkg_postinst() {
	gnome2_pkg_postinst
	ewarn "If ${PN} does not rip to some music format, please check your USE flags"
	ewarn "on media-libs/libgnome-media-profiles and media-plugins/gst-plugins-meta"
	ewarn
	ewarn "The list of audio encoding profiles in ${P} is non-customizable."
	ewarn "A possible workaround is to rip to flac using ${PN}, and convert to"
	ewarn "your desired format using a separate tool."
}
