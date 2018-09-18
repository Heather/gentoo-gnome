# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome.org meson vala

DESCRIPTION="Tracker miners and metadata extractors"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cue enca exif ffmpeg flac gif gsf gstreamer iptc +iso +jpeg libav
+miner-fs mp3 pdf playlist png rss systemd test +tiff upnp-av upower
+vorbis +xml xmp xps"

REQUIRED_USE="
	?? ( gstreamer ffmpeg )
	enca? ( mp3 )
	upnp-av? ( gstreamer )
	!miner-fs? ( !cue !exif !flac !gif !gsf !iptc !iso !jpeg !mp3 !pdf !playlist !png !tiff !vorbis !xml !xmp !xps )
"

RDEPEND="
	>=app-misc/tracker-2.1.4
	>=dev-libs/glib-2.40:2
	>sys-apps/dbus-1.3.1
	>=sys-libs/libseccomp-2.0

	cue? ( media-libs/libcue )
	enca? ( >=app-i18n/enca-1.9:= )
	!enca? ( >=dev-libs/icu-4.8.1.1:= )
	exif? ( >=media-libs/libexif-0.6 )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	flac? ( >=media-libs/flac-1.2.1 )
	gif? ( media-libs/giflib:= )
	gsf? ( >=gnome-extra/libgsf-1.14.24 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	iptc? ( media-libs/libiptcdata )
	iso? ( >sys-libs/libosinfo-0.2.9:= )
	jpeg? ( virtual/jpeg:0 )
	upower? ( || ( >sys-power/upower-0.9.0[introspection] sys-power/upower-pm-utils[introspection] ) )
	mp3? ( >media-libs/taglib-1.6 )
	pdf? ( >app-text/poppler-0.16.0[introspection] )
	playlist? ( >=dev-libs/totem-pl-parser-3 )
	png? ( >=media-libs/libpng-0.89:0= )
	rss? ( >=net-libs/libgrss-0.7:0 )
	systemd? ( sys-apps/systemd )
	tiff? ( media-libs/tiff:0 )
	upnp-av? ( >=media-libs/gupnp-dlna-0.9.4:2.0 )
	vorbis? ( >media-libs/libvorbis-0.22 )
	xml? ( >dev-libs/libxml2-2.6 )
	xmp? ( >=media-libs/exempi-2.1.0 )
	xps? ( app-text/libgxps )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dabiword=true
		-Dbattery_detection=$(usex upower upower none)
		-Dcharset_detection=$(usex enca enca icu)
		-Ddvi=true
		-Dicon=true
		-Dminer_apps=true
		-Dminer_fs=$(usex miner-fs true false)
		-Dminer_rss=$(usex rss true false)
		-Dmp3=$(usex mp3 true false)
		-Dps=true
		-Dsystemd_user_services=$(usex systemd yes no)
		-Dtext=true
		-Dunzip_ps_gz_files=true
	)

	if use gstreamer; then
		emesonargs+=(-Dgeneric_media_extractor=gstreamer)
		if use upnp-av; then
			emesonargs+=(-Dgstreamer_backend=gupnp)
		else
			emesonargs+=(-Dgstreamer_backend=discoverer)
		fi
	elif use ffmpeg; then
		emesonargs+=(-Dgeneric_media_extractor=libav)
	else
		emesonargs+=(-Dgeneric_media_extractor=none)
	fi

	# configure fails without this option
	emesonargs+=(-Dfunctional_tests=False)

	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use rss; then
		rm -f "${ED}"/usr/share/tracker/miners/org.freedesktop.Tracker1.Miner.RSS.service
	fi
}
