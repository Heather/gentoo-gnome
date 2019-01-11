# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_PV="${PV%_*}"
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${MY_P}"

RESTRICT="mirror"

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
SRC_URI="https://github.com/PipeWire/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="docs gstreamer systemd"

RDEPEND="
	media-libs/alsa-lib
	media-libs/sbc
	media-video/ffmpeg:=
	sys-apps/dbus
	virtual/libudev
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	systemd? ( sys-apps/systemd )
"
DEPEND="
	${RDEPEND}
	app-doc/xmltoman
	docs? ( app-doc/doxygen )
"

src_configure() {
	local emesonargs=(
		-Denable_gstreamer="$(usex gstreamer true false)"
		-Denable_man="true"
		-Denable_docs="$(usex docs true false)"
		-Denable_systemd="$(usex systemd true false)"
	)
	meson_src_configure
}
