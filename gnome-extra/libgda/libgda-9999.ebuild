# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgda/libgda-4.2.0.ebuild,v 1.3 2010/11/01 12:18:13 eva Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"
PYTHON_DEPEND="2"

inherit db-use eutils flag-o-matic gnome2 java-pkg-opt-2 python
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Gnome Database Access Library"
HOMEPAGE="http://www.gnome-db.org/"
LICENSE="GPL-2 LGPL-2"

IUSE="berkdb bindist canvas doc firebird gnome-keyring gtk graphviz http +introspection json ldap mdb mysql oci8 postgres sourceview ssl"
SLOT="5"
if [[ ${PV} = 9999 ]]; then
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
	dev-libs/libunique:3
	sys-libs/readline
	sys-libs/ncurses
	berkdb?   ( sys-libs/db )
	!bindist? ( firebird? ( dev-db/firebird ) )
	gtk? (
		>=x11-libs/gtk+-3.0.0:3
		canvas? ( x11-libs/goocanvas:2.0 )
		sourceview? ( x11-libs/gtksourceview:3.0 )
		graphviz? ( media-gfx/graphviz )
	)
	gnome-keyring? ( || ( gnome-base/libgnome-keyring <gnome-base/gnome-keyring-2.29.4 ) )
	http? ( >=net-libs/libsoup-2.24:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.5 )
	json?     ( dev-libs/json-glib )
	ldap?     ( net-nds/openldap )
	mdb?      ( >app-office/mdbtools-0.5 )
	mysql?    ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	ssl?      ( dev-libs/openssl )
	>=dev-db/sqlite-3.6.22:3"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.18
	>=dev-util/intltool-0.35.5
	>=app-text/gnome-doc-utils-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

# XXX: some tests fail when run from portage (but pass when building by hand)
RESTRICT="test"

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
		$(use_with ldap)
		$(use_with mdb mdb /usr)
		$(use_with mysql mysql /usr)
		$(use_with postgres postgres /usr)
		$(use_enable ssl crypto)"

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

	export XDG_DATA_HOME="${T}/.local"

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Fix build order for generated content, upstream #630958
	#epatch "${FILESDIR}/${PN}-9999-fix-build-order.patch"

	# Fix compilation failure of keyword_hash.c, upstream #630959
	#epatch "${FILESDIR}/${PN}-4.2.0-missing-include-in-keyword_hash-generator.patch"

	# Disable broken tests so we can check the others
	epatch "${FILESDIR}/${PN}-9999-disable-broken-tests.patch"

	# Prevent file collisions with libgda:4
	epatch "${FILESDIR}/${PN}-4.99.1-gda-browser-help-collision.patch"
	epatch "${FILESDIR}/${PN}-4.99.1-gda-browser-doc-collision.patch"
	epatch "${FILESDIR}/${PN}-4.99.1-control-center-icon-collision.patch"
	# Move files with mv (since epatch can't handle rename diffs) and
	# update pre-generated gtk-doc files (for non-git versions of libgda)
	local f
	for f in tools/browser/doc/gda-browser* ; do
		mv ${f} ${f/gda-browser/gda-browser-5.0} || die "mv ${f} failed"
	done
	if [[ ${PV} != 9999 ]] ; then
		for f in tools/browser/doc/html/gda-browser.devhelp* ; do
			sed -e 's:name="gda-browser":name="gda-browser-5.0":' \
				-i ${f} || die "sed ${f} failed"
			mv ${f} ${f/gda-browser/gda-browser-5.0} || die "mv ${f} failed"
		done
	fi
	for f in control-center/data/*_gda-control-center.png ; do
		mv ${f} ${f/_gda-control-center.png/_gda-control-center-5.0.png} ||
			die "mv ${f} failed"
	done

	python_convert_shebangs -r 2 libgda-report/RML/trml2{html,pdf}

	gnome2_src_prepare
}

src_test() {
	emake check XDG_DATA_HOME="${T}/.local" || die "tests failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	local d
	for d in /usr/share/libgda-5.0/gda_trml2{html,pdf} ; do
		python_mod_optimize ${d}
	done
}

pkg_postrm() {
	gnome2_pkg_postrm
	local d
	for d in /usr/share/libgda-5.0/gda_trml2{html,pdf} ; do
		python_mod_cleanup ${d}
	done
}
