# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-3.2.1.ebuild,v 1.1 2011/11/06 04:57:01 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2 pax-utils versionator virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="http://projects.gnome.org/epiphany/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc +introspection +jit +nss test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

RDEPEND="
	>=app-crypt/gcr-3.5.5
	>=app-text/iso-codes-0.35
	>=dev-libs/glib-2.31.2:2
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/gnome-keyring-2.26.0
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=net-dns/avahi-0.6.22
	>=net-libs/webkit-gtk-1.9.90:3[introspection?]
	>=net-libs/libsoup-gnome-2.39.6:2.4
	>=x11-libs/gtk+-3.5.2:3[introspection?]
	>=x11-libs/libnotify-0.5.1

	dev-db/sqlite:3
	x11-libs/libX11

	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	!jit? ( net-libs/webkit-gtk[-jit] )
	nss? ( dev-libs/nss )"
# paxctl needed for bug #407085
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50
	sys-apps/paxctl
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"
	G2CONF="${G2CONF}
		--enable-shared
		--disable-schemas-compile
		--disable-static
		--with-distributor-name=Gentoo
		$(use_enable introspection)
		$(use_enable nss)
		$(use_enable test tests)"
}

src_prepare() {
	# Build-time segfaults under PaX with USE=introspection when building
	# against webkit-gtk[introspection,jit]
	if use introspection && use jit; then
		epatch "${FILESDIR}/${PN}-3.3.90-paxctl-introspection.patch"
		cp "${FILESDIR}/paxctl.sh" "${S}/" || die
		[[ ${PV} != 9999 ]] && eautoreconf
	fi
	gnome2_src_prepare
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}

src_install() {
	gnome2_src_install
	use jit && pax-mark m "${ED}usr/bin/epiphany"
}
