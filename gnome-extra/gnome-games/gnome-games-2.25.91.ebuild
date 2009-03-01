# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-games/gnome-games-2.24.3.ebuild,v 1.3 2009/01/31 21:48:30 eva Exp $
EAPI=2

GCONF_DEBUG="no"

# make sure games is inherited first so that the gnome2
# functions will be called if they are not overridden
inherit games games-ggz eutils gnome2 python virtualx

DESCRIPTION="Collection of games for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/GnomeGames/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="artworkextra guile opengl"

RDEPEND=">=gnome-base/libgnomeui-2.16.0
	>=gnome-base/libgnome-2.16.0
	>=dev-python/pygtk-2.10
	>=x11-libs/gtk+-2.12

	>=dev-python/gconf-python-2.17.3
	>=dev-python/bug-buddy-python-2.17.3
	>=dev-python/libgnome-python-2.17.3
	>=dev-python/libgnomeprint-python-2.17.3
	>=dev-python/gnome-applets-python-2.17.3
	>=dev-python/gnome-desktop-python-2.17.3
	>=dev-python/gnome-keyring-python-2.17.3
	>=dev-python/gnome-media-python-2.17.3
	>=dev-python/gnome-vfs-python-2.17.3
	>=dev-python/libgnomecanvas-python-2.17.3

	>=x11-libs/cairo-1
	>=dev-python/pycairo-1
	>=gnome-base/gconf-2
	>=dev-libs/libxml2-2.4.0
	>=gnome-base/librsvg-2.14
	>=media-libs/gstreamer-0.10.11
	>=gnome-base/libglade-2
	>=dev-libs/glib-2.6.3
	>=dev-games/libggz-0.0.14
	>=dev-games/ggz-client-libs-0.0.14
	guile? ( >=dev-scheme/guile-1.6.5[deprecated,regex] )
	artworkextra? ( gnome-extra/gnome-games-extra-data )
	opengl? ( dev-python/pygtkglext )
	!games-board/glchess"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.53
	>=dev-util/pkgconfig-0.15
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.10.40
	>=gnome-base/gnome-common-2.12.0
	>=app-text/scrollkeeper-0.3.8
	  app-text/gnome-doc-utils"

# Others are installed below; multiples in this package.
DOCS="AUTHORS HACKING MAINTAINERS TODO"

# dang make-check fails on docs with -j > 1.  Restrict them for the moment until
# it can be chased down.
RESTRICT="test"

pkg_setup() {
	# create the games user / group
	games_pkg_setup

	G2CONF="${G2CONF}
		--with-scores-group=${GAMES_GROUP}
		--enable-noregistry=\"${GGZ_MODDIR}\"
		--with-platform=gnome
		--with-sound=gstreamer
		--enable-scalable"

	if ! use guile; then
		ewarn "USE='-guile' implies that Aisleriot won't be installed"
		G2CONF="${G2CONF} --enable-omitgames=aisleriot"
	fi
}

src_prepare() {
	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_test() {
	Xemake check || die "tests failed"
}

src_install() {
	gnome2_src_install

	# Documentation install for each of the games
	for game in \
	$(find . -maxdepth 1 -type d ! -name po ! -name libgames-support); do
		docinto ${game}
		for doc in AUTHORS ChangeLog NEWS README TODO; do
			[ -s ${game}/${doc} ] && dodoc ${game}/${doc}
		done
	done
}

pkg_preinst() {
	gnome2_pkg_preinst
	# Avoid overwriting previous .scores files
	local basefile
	for scorefile in "${D}"/var/lib/games/*.scores; do
		basefile=$(basename $scorefile)
		if [ -s "${ROOT}/var/lib/games/${basefile}" ]; then
			cp "${ROOT}/var/lib/games/${basefile}" \
			"${D}/var/lib/games/${basefile}"
		fi
	done
}

pkg_postinst() {
	games_pkg_postinst
	games-ggz_update_modules
	gnome2_pkg_postinst

	python_need_rebuild
	python_mod_optimize $(python_get_sitedir)/{gnome_sudoku,glchess}
}

pkg_postrm() {
	games-ggz_update_modules
	gnome2_pkg_postrm

	python_mod_cleanup $(python_get_sitedir)/{gnome_sudoku,glchess}
}
