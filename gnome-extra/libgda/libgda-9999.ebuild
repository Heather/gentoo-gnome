# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgda/libgda-4.2.0.ebuild,v 1.3 2010/11/01 12:18:13 eva Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit db-use eutils flag-o-matic gnome2 gnome2-live java-pkg-opt-2

DESCRIPTION="Gnome Database Access Library"
HOMEPAGE="http://www.gnome-db.org/"
LICENSE="GPL-2 LGPL-2"

# MDB support currently works with CVS only, so disable it in the meantime
IUSE="berkdb bindist canvas doc firebird gnome-keyring gtk graphviz http +introspection json mysql oci8 postgres sourceview ssl"
SLOT="4"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

# FIXME: sqlite is automagic, but maybe it is a hard-dep
# FIXME: autoconf is a hell of inconsistencies
RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.16:2
	>=dev-libs/libxml2-2
	dev-libs/libxslt
	dev-libs/libunique:1
	sys-libs/readline
	sys-libs/ncurses
	berkdb?   ( sys-libs/db )
	!bindist? ( firebird? ( dev-db/firebird ) )
	gtk? (
		>=x11-libs/gtk+-2.12:2
		canvas? ( x11-libs/goocanvas )
		sourceview? ( x11-libs/gtksourceview:2.0 )
		graphviz? ( media-gfx/graphviz )
	)
	gnome-keyring? ( || ( gnome-base/libgnome-keyring <gnome-base/gnome-keyring-2.29.4 ) )
	http? ( >=net-libs/libsoup-2.24:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.5 )
	json?     ( dev-libs/json-glib )
	mysql?    ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	ssl?      ( dev-libs/openssl )
	>=dev-db/sqlite-3.6.22:3"
#	mdb?      ( >app-office/mdbtools-0.5 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.18
	>=dev-util/intltool-0.35.5
	>=app-text/gnome-doc-utils-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"

	if use canvas || use graphviz || use sourceview; then
		if ! use gtk; then
			ewarn "You must enable USE=gtk to make use of canvas, graphivz or sourceview USE flag."
			ewarn "Disabling for now."
			G2CONF="${G2CONF} --without-goocanvas --without-graphivz --without-gtksourceview"
		else
			G2CONF="${G2CONF}
				$(use_with canvas goocanvas)
				$(use_with graphviz)
				$(use_with sourceview gtksourceview)"
		fi
	fi

	G2CONF="${G2CONF}
		--with-unique
		--disable-scrollkeeper
		--disable-static
		--enable-system-sqlite
		$(use_with berkdb bdb /usr)
		$(use_with gnome-keyring)
		$(use_with gtk ui)
		$(use_with http libsoup)
		$(use_enable introspection)
		$(use_with java java $JAVA_HOME)
		$(use_enable json)
		$(use_with mysql mysql /usr)
		$(use_with postgres postgres /usr)
		$(use_enable ssl crypto)
		--without-mdb"
#		$(use_with mdb mdb /usr)

	if use bindist; then
		# firebird license is not GPL compatible
		G2CONF="${G2CONF} --without-firebird"
	else
		G2CONF="${G2CONF} $(use_with firebird firebird /usr)"
	fi

	use berkdb && append-cppflags "-I$(db_includedir)"
	use oci8 || G2CONF="${G2CONF} --without-oracle"

	# Not in portage
	G2CONF="${G2CONF}
		--disable-default-binary"
}

src_prepare() {
	# Fix build order for generated content, upstream #630958
	#epatch "${FILESDIR}/${PN}-9999-fix-build-order.patch"

	# Fix compilation failure of keyword_hash.c, upstream #630959
	#epatch "${FILESDIR}/${PN}-4.2.0-missing-include-in-keyword_hash-generator.patch"

	# Disable broken tests so we can check the others
	epatch "${FILESDIR}/${PN}-9999-disable-broken-tests.patch"

	gnome2-live_src_prepare
}

src_test() {
	emake check XDG_DATA_HOME="${T}/.local" || die "tests failed"
}
