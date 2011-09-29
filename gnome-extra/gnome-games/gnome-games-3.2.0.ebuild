# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-games/gnome-games-2.30.1.ebuild,v 1.1 2010/06/13 21:47:18 pacho Exp $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
WANT_AUTOMAKE="1.11"
PYTHON_DEPEND="2:2.4"
PYTHON_USE_WITH="xml"

# make sure games is inherited first so that the gnome2
# functions will be called if they are not overridden
inherit autotools games eutils gnome2 python virtualx

DESCRIPTION="Collection of games for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/GnomeGames/"

LICENSE="GPL-2 GPL-3 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="artworkextra +aisleriot +clutter +introspection glchess seed +sudoku test"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.75
	>=dev-libs/glib-2.25.7
	>=dev-libs/libxml2-2.4.0
	>=gnome-base/gconf-2.31.1
	>=gnome-base/librsvg-2.32
	>=x11-libs/cairo-1
	>=x11-libs/gtk+-2.91.7:3[introspection?]

	media-libs/libcanberra[gtk3]
	x11-libs/libSM

	artworkextra? ( >=gnome-extra/gnome-games-extra-data-3.0.0 )
	clutter? (
		>=dev-libs/gobject-introspection-0.6.3
		>=x11-libs/gtk+-2.90:3[introspection]
		>=gnome-base/gconf-2.31.1[introspection]
		>=media-libs/clutter-gtk-0.91.6:1.0[introspection]
		seed? ( >=dev-libs/seed-2.91.90 ) )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.3
		media-libs/clutter:1.0[introspection] )
	glchess? (
		dev-db/sqlite:3
		>=gnome-base/librsvg-2.32
		virtual/opengl
		x11-libs/libX11 )"
RDEPEND="${COMMON_DEPEND}
	sudoku? (
		|| ( dev-python/pygobject:3 >=dev-python/pygobject-2.28.3:2[introspection] )
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/pango[introspection]
		>=x11-libs/gtk+-3.0.0:3[introspection] )

	!<gnome-extra/gnome-games-extra-data-3.0.0"
DEPEND="${COMMON_DEPEND}
	glchess? ( >=dev-lang/vala-0.13.0:0.14 )
	>=dev-util/pkgconfig-0.15
	>=dev-util/intltool-0.40.4
	>=sys-devel/gettext-0.10.40
	>=gnome-base/gnome-common-2.12.0
	>=app-text/scrollkeeper-0.3.8
	>=app-text/gnome-doc-utils-0.10
	test? ( >=dev-libs/check-0.9.4 )"

# For compatibility with older versions of the gnome-games package
PDEPEND="aisleriot? ( games-board/aisleriot )"

# Others are installed below; multiples in this package.
DOCS="AUTHORS HACKING MAINTAINERS TODO"

_omitgame() {
	G2CONF="${G2CONF},${1}"
}

pkg_setup() {
	# create the games user / group
	games_pkg_setup

	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-schemas-compile
		--enable-sound
		$(use_enable introspection)"

	# Should be after $(use_enable introspection), but before --enable-omitgames
	use clutter && G2CONF="${G2CONF} --enable-introspection"

	use glchess && G2CONF="${G2CONF} VALAC=$(type -p valac-0.14)"

	# Staging games are needed for swell-foop and lightsoff
	G2CONF="${G2CONF}
		--enable-staging
		--with-scores-group=${GAMES_GROUP}
		--with-platform=gnome
		--with-smclient
		--with-gtk=3.0
		--enable-omitgames=none" # This line should be last for _omitgame

	if ! use clutter; then
		ewarn "USE='-clutter' => quadrapassel, swell-foop, lightsoff, gnibbles won't be installed"
		_omitgame quadrapassel
		_omitgame gnibbles
		_omitgame swell-foop
		_omitgame lightsoff
		use seed && ewarn "USE='seed' has no effect with USE='-clutter'"
	elif ! use seed; then
		ewarn "USE='-seed' => swell-foop, lightsoff won't be installed"
		_omitgame swell-foop
		_omitgame lightsoff
	fi

	if ! use glchess; then
		_omitgame glchess
	fi

	if ! use sudoku; then
		_omitgame gnome-sudoku
	fi
}

src_prepare() {
	gnome2_src_prepare

	use sudoku && python_convert_shebangs -r 2 gnome-sudoku/src

	# TODO: File upstream bug for this
	epatch "${FILESDIR}/${PN}-2.91.90-fix-conditional-ac-prog-cxx.patch"

	# Without this, --enable-staging enables all those games unconditionally
	epatch "${FILESDIR}/${PN}-fix-staging-games.patch"

	eautoreconf

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
	for scorefile in "${ED}"/var/lib/games/*.scores; do
		basefile=$(basename $scorefile)
		if [ -s "${EROOT}/var/lib/games/${basefile}" ]; then
			cp "${EROOT}/var/lib/games/${basefile}" \
			"${ED}/var/lib/games/${basefile}"
		fi
	done
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_pkg_postinst
	python_need_rebuild
	use sudoku && python_mod_optimize gnome_sudoku
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup gnome_sudoku
}
