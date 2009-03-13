# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/farsight/farsight-0.1.18.ebuild,v 1.1 2007/04/30 22:08:59 tester Exp $
EAPI=2

DESCRIPTION="Farsight2 is an audio/video conferencing framework specifically designed for Instant Messengers."
HOMEPAGE="http://farsight.freedesktop.org/"
SRC_URI="http://farsight.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="python"
SLOT="0"

COMMONDEPEND=">=media-libs/gstreamer-0.10.20
	>=media-libs/gst-plugins-base-0.10.20
	>=dev-libs/glib-2.14
	>=net-libs/libnice-0.0.3
	python? (
		>=dev-python/pygobject-2.12
		>=dev-python/pygtk-2.10
		>=dev-python/gst-python-0.10.10 )"

RDEPEND="${COMMONDEPEND}
	>=media-libs/gst-plugins-good-0.10.11
	|| (
		(	<media-libs/gst-plugins-bad-0.10.11
			~media-plugins/gst-plugins-farsight-0.12.10 )
		(	>=media-libs/gst-plugins-bad-0.10.11
			>=media-plugins/gst-plugins-farsight-0.12.11 ) )"

DEPEND="${COMMONDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.8 )"

src_configure() {
	econf \
		$(use_enable python) \
		--with-plugins=fsrtpconference,funnel,videoanyrate \
		--with-transmitter-plugins=nice,multicast,rawudp
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS README ChangeLog
}
