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
IUSE="avahi doc +introspection +nss test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

# XXX: Should we add seed support? Seed seems to be unmaintained now.
RDEPEND=">=dev-libs/glib-2.31.2:2
	>=x11-libs/gtk+-3.3.14:3[introspection?]
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=app-text/iso-codes-0.35
	>=net-libs/webkit-gtk-1.7.3:3[introspection?]
	>=net-libs/libsoup-gnome-2.37.1:2.4
	>=gnome-base/gnome-keyring-2.26.0
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=x11-libs/libnotify-0.5.1

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11

	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic

	avahi? ( >=net-dns/avahi-0.6.22 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	nss? ( dev-libs/nss )"
# paxctl needed for bug #407085
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-apps/paxctl
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"
	G2CONF="${G2CONF}
		--enable-shared
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static
		--with-distributor-name=Gentoo
		$(use_enable avahi zeroconf)
		$(use_enable introspection)
		$(use_enable nss)
		$(use_enable test tests)"
}

src_prepare() {
	# Build-time segfaults under PaX with USE=introspection
	epatch "${FILESDIR}/${PN}-3.3.90-paxctl-introspection.patch"
	cp "${FILESDIR}/paxctl.sh" "${S}/" || die
	eautoreconf
	gnome2_src_prepare
}

src_test() {
	# Tests require gsettings schemas from >=epiphany-3.3.5 to be installed
	local v=$(best_version www-client/epiphany)
	v=${v/www-client\/epiphany-/}
	if version_is_at_least 3.3.5 "${v}"; then
		Xemake check
	else
		ewarn "Skipping tests. To run tests, >=${PN}-3.3.5 needs to be already"
		ewarn "installed on the system."
	fi
}

src_install() {
	gnome2_src_install
	pax-mark m "${ED}usr/bin/epiphany"
}
