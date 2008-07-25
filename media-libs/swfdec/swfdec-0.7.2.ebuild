# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/swfdec/swfdec-0.6.6-r1.ebuild,v 1.1 2008/06/20 21:34:31 cardoe Exp $

EAPI=1

inherit eutils versionator confutils

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Macromedia Flash decoding library"
HOMEPAGE="http://swfdec.freedesktop.org"
SRC_URI="http://swfdec.freedesktop.org/download/${PN}/${MY_PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="alsa doc ffmpeg gstreamer gtk oss pulseaudio"

RDEPEND=">=dev-libs/glib-2.12
	>=dev-libs/liboil-0.3.1
	>=x11-libs/pango-1.16.4
	gtk? (
		>=x11-libs/gtk+-2.8.0
		net-libs/libsoup:2.4
		)
	>=x11-libs/cairo-1.2
	gstreamer? (
		>=media-libs/gstreamer-0.10.11
		>=media-libs/gst-plugins-base-0.10.15
		ffmpeg? ( media-plugins/gst-plugins-ffmpeg )
		)
	alsa? ( >=media-libs/alsa-lib-1.0.12 )
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.6 )"

pkg_setup() {
	if use !gtk ; then
		ewarn "swfdec will be built without swfdec-gtk convenience"
		ewarn "library, which is needed by swfdec-mozilla and"
		ewarn "swfdec-gnome. Please add 'gtk' to your USE flags"
		ewarn "unless you really know what you are doing."
	fi

	if use !gstreamer && use ffmpeg; then
		ewarn
		ewarn "The 'ffmpeg' USE flag enables video support via gst-plugins-ffmpeg"
		ewarn "as such it requires the 'gstreamer' USE flag to be enabled."
	fi

	confutils_use_conflict oss alsa pulseaudio
}

src_compile() {
	local myconf=

	#--with-audio=[auto/alsa/oss/none]
	use oss && myconf="${myconf} --with-audio=oss"
	use pulseaudio && myconf="${myconf} --with-audio=pa"
	use alsa && myconf="${myconf} --with-audio=alsa"

	# bug #216009
	# avoid writing to /root/.gstreamer-0.10/registry.xml
	export GST_REGISTRY="${T}"/registry.xml
	# also avoid loading gconf plugins, which may write to /root/.gconfd
	export GST_PLUGIN_SYSTEM_PATH="${T}"

	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable gstreamer) \
		$(use_enable gtk) \
		--disable-ffmpeg \
		--disable-mad \
		${myconf} || die "configure failed"

	# bug #216284 image tests are not ready yet
	cat  >test/image/Makefile <<EOF
all:
check:
install:
EOF

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
