# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgda/libgda-3.0.4.ebuild,v 1.8 2009/02/27 23:12:07 jer Exp $

EAPI="2"

inherit autotools db-use flag-o-matic gnome2 java-pkg-opt-2

DESCRIPTION="Gnome Database Access Library"
HOMEPAGE="http://www.gnome-db.org/"
LICENSE="GPL-2 LGPL-2"

# MDB support currently works with CVS only, so disable it in the meantime
IUSE="berkdb bindist doc firebird freetds ldap mysql oci8 odbc postgres xbase"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# FIXME: sqlite is automagic, but maybe it is a hard-dep
# FIXME: autoconf is a hell of inconsistencies
RDEPEND=">=dev-libs/glib-2.16
	>=dev-libs/libxml2-2
	dev-libs/libxslt
	sys-libs/readline
	sys-libs/ncurses
	>=net-libs/libsoup-2.24
	berkdb?   ( sys-libs/db )
	odbc?     ( >=dev-db/unixODBC-2.0.6 )
	mysql?    ( virtual/mysql )
	postgres? ( >=virtual/postgresql-base-7.2.1 )
	freetds?  ( >=dev-db/freetds-0.62 )
	!bindist? ( firebird? ( dev-db/firebird ) )
	xbase?    ( dev-db/xbase )
	ldap?     ( >=net-nds/openldap-2.0.25 )
	>=dev-db/sqlite-3.6.11:3"
#   json?     ( dev-libs/json-glib )
#	mdb?      ( >app-office/mdbtools-0.5 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.18
	>=dev-util/intltool-0.35.5
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

# Tests are not really good
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-libsoup
		 --enable-system-sqlite
		$(use_with berkdb bdb /usr)
		$(use_with odbc odbc /usr)
		$(use_with mysql mysql /usr)
		$(use_with postgres postgres /usr)
		$(use_with freetds tds /usr)
		$(use_with xbase xbase /usr)
		$(use_with ldap ldap /usr)
		$(use_with java java $JAVA_HOME)
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
		--without-msql
		--without-sybase
		--without-ibmdb2
		--disable-default-binary"
}

src_prepare() {
	gnome2_src_prepare

	# Fix sandbox violations
	epatch "${FILESDIR}/${PN}-4.0.2-sandbox.patch"

	# Fix automagic libsoup support
	epatch "${FILESDIR}/${PN}-4.0.2-libsoup-magic.patch"

	eautoreconf
}

src_test() {
	emake check HOME=$(unset HOME; echo "~") || die "tests failed"
}
