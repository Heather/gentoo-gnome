# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tumbler is a D-Bus service for applications to request thumbnails"
HOMEPAGE="https://github.com/xfce-mirror/tumbler"
SRC_URI="SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="ffmpeg curl gstreamer jpeg odf pdf raw"

DEPEND="
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${DEPEND}
	>=dev-libs/glib-2.26.0:2
	>=x11-libs/gdk-pixbuf-2.14:2=
	>=media-libs/libpng-1.2.0
	media-libs/freetype:2=
	>=sys-apps/dbus-1.6:=
	curl? ( >=net-misc/curl-7.25:= )
	ffmpeg? ( >=media-video/ffmpegthumbnailer-2.0.8:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		)
	jpeg? ( virtual/jpeg:0= )
	odf? ( >=gnome-extra/libgsf-1.14.20:= )
	pdf? ( >=app-text/poppler-0.12.4[cairo] )
	raw? ( >=media-libs/libopenraw-0.0.8:=[gtk] )
"

src_configure() {
	local myconf=(
		$(use_enable curl cover-thumbnailer)
		$(use_enable jpeg jpeg-thumbnailer)
		$(use_enable ffmpeg ffmpeg-thumbnailer)
		$(use_enable gstreamer gstreamer-thumbnailer)
		$(use_enable odf odf-thumbnailer)
		$(use_enable pdf poppler-thumbnailer)
		$(use_enable raw raw-thumbnailer)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
