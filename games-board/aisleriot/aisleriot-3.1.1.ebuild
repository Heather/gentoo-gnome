# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"

# make sure games is inherited first so that the gnome2
# functions will be called if they are not overridden
inherit eutils games gnome2

DESCRIPTION="A collection of solitaire card games for GNOME"
HOMEPAGE="http://live.gnome.org/Aisleriot"

LICENSE="GPL-3 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="artworkextra gnome sound"

# FIXME: quartz support?
COMMON_DEPEND=">=dev-libs/glib-2.26.0:2
	>=dev-scheme/guile-1.8.0:12[deprecated,regex]
	>=gnome-base/librsvg-2.32.0
	>=x11-libs/cairo-1.10.0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.0.0:3
	x11-libs/libICE
	x11-libs/libSM
	gnome? ( >=gnome-base/gconf-2.0:2 )
	sound? ( >=media-libs/libcanberra-0.26[gtk3] )"
# aisleriot was split off from gnome-games
RDEPEND="${COMMON_DEPEND}
	artworkextra? ( >=gnome-extra/gnome-games-extra-data-3.0.0 )
	!!<gnome-extra/gnome-games-3.1.1[aisleriot]"
DEPEND="${COMMON_DEPEND}
	>=app-text/gnome-doc-utils-0.10
	>=dev-util/intltool-0.40.4
	>=dev-util/pkgconfig-0.15
	sys-apps/lsb-release
	>=sys-devel/gettext-0.12"

pkg_setup() {
	DOCS="AUTHORS ChangeLog TODO"

	if use gnome; then
		G2CONF="${G2CONF} --with-platform=gnome --with-help-method=ghelp"
	else
		G2CONF="${G2CONF} --with-platform=gtk-only --with-help-method=library"
	fi

	if use artworkextra; then
		G2CONF="${G2CONF} --with-card-theme-formats=all
			--with-kde-card-theme-path=${EPREFIX}usr/share/apps/carddecks
			--with-pysol-card-theme-path=${EPREFIX}${GAMES_DATADIR}/pysolfc"
	else
		G2CONF="${G2CONF} --with-card-theme-formats=default"
	fi

	# Disable clutter per upstream recommendation in configure.ac
	G2CONF="${G2CONF}
		--with-gtk=3.0
		--without-clutter
		--with-smclient
		--with-guile=1.8
		$(use_enable sound)
		--disable-schemas-compile
		--disable-maintainer-mode"
}

src_prepare() {
	gnome2_src_prepare

	# https://bugzilla.gnome.org/show_bug.cgi?id=656967
	epatch "${FILESDIR}/${P}-help-directory.patch"
}
pkg_postinst() {
	gnome2_pkg_postinst

	if use artworkextra; then
		elog "Aisleriot can use additional card themes from games-board/pysolfc"
		elog "and kde-base/libkdegames."
	fi
}
