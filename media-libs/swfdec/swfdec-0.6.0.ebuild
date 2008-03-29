# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/swfdec/swfdec-0.5.5.ebuild,v 1.2 2008/01/29 20:50:49 drac Exp $

EAPI=1

inherit eutils versionator confutils

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Macromedia Flash decoding library"
HOMEPAGE="http://swfdec.freedesktop.org"
SRC_URI="http://swfdec.freedesktop.org/download/${PN}/${MY_PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="alsa doc ffmpeg gstreamer mad oss pulseaudio soup"

# fails tests, double check on next bump
RESTRICT="test"

RDEPEND=">=dev-libs/glib-2.12
	>=dev-libs/liboil-0.3.1
	>=x11-libs/pango-1.16.4
	soup? (
		>=x11-libs/gtk+-2.8.0
		net-libs/libsoup:2.4
		)
	>=x11-libs/cairo-1.2
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20070330 )
	mad? ( >=media-libs/libmad-0.15.1b )
	gstreamer? (
		>=media-libs/gstreamer-0.10.11
		>=media-libs/gst-plugins-base-0.10.15
		)
	alsa? ( >=media-libs/alsa-lib-1.0.12 )
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.6 )"

pkg_setup() {
	if use ppc && use ffmpeg ; then
		eerror "swfdec doesn't work with latest ffmpeg version in"
		eerror "ppc arch. See bug #11841 in Freedesktop Bugzilla."
		eerror "Please disable ffmpeg flag and enable gstreamer"
		die "Depends failed"
	fi
	if use !soup ; then
		ewarn "swfdec will be built without HTTP protocol support"
		ewarn "so you won't be able to use swfdec-mozilla, please"
		ewarn "add 'soup' to your USE flags"
	fi
	confutils_use_conflict oss alsa pulseaudio
}

src_compile() {
	local myconf
	local myaudio

	#--with-audio=[auto/alsa/oss/none]
	myaudio="none"
	use oss && myaudio="oss"
	use pulseaudio && myaudio="pa"
	use alsa && myaudio="alsa"
	myconf=" --with-audio=$myaudio"

	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable gstreamer) \
		$(use_enable ffmpeg) \
		$(use_enable mad) \
		$(use_enable soup gtk) \
		${myconf} || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
