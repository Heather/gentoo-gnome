# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/grilo-plugins/grilo-plugins-0.1.16.ebuild,v 1.1 2011/08/14 10:52:41 nirbheek Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="A framework for easy media discovery and browsing"
HOMEPAGE="https://live.gnome.org/Grilo"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+youtube +vimeo upnp"

RDEPEND="
	>=dev-libs/glib-2.26:2
	=media-libs/grilo-${PV}[network]

	|| ( dev-libs/gmime:2.6 dev-libs/gmime:2.4 )
	dev-libs/libxml2:2
	dev-db/sqlite:3

	youtube? ( >=dev-libs/libgdata-0.7
		>=media-libs/quvi-0.2.15 )
	upnp? ( >=net-libs/gupnp-0.13
		>=net-libs/gupnp-av-0.5 )
	vimeo? ( net-libs/libsoup:2.4
		dev-libs/libgcrypt )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

# `make check` doesn't do anything, and ${S}/test/test fails without all plugins
RESTRICT="test"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	# --enable-debug only changes CFLAGS, useless for us
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-debug
		--disable-uninstalled"

	# Plugins
	# TODO: Enable tracker support (requires tracker-0.10.5+)
	# TODO: Enable Blip.TV support (requires librest)
	G2CONF="${G2CONF}
		--enable-apple-trailers
		--enable-bookmarks
		--enable-filesystem
		--enable-flickr
		--enable-gravatar
		--enable-jamendo
		--enable-lastfm-albumart
		--enable-localmetadata
		--enable-metadata-store
		--enable-podcasts
		--disable-bliptv
		--disable-shoutcast
		--disable-tracker
		$(use_enable upnp)
		$(use_enable youtube)
		$(use_enable vimeo)"
}

src_prepare() {
	sed -i -e 's/^\(SUBDIRS .*\)test/\1/g' Makefile.*

	epatch "${FILESDIR}/${P}-apple-trailers-fix.patch"

	eautoreconf

	gnome2_src_prepare
}
