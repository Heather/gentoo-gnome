# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/evolution/evolution-2.32.1-r1.ebuild,v 1.3 2011/01/15 19:56:39 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="xz"
PYTHON_DEPEND="python? 2:2.4"

inherit autotools flag-o-matic gnome2 python
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="GPL-2 LGPL-2 OPENLDAP"
SLOT="2.0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="clutter connman crypt doc gstreamer kerberos ldap map networkmanager python ssl"

# We need a graphical pinentry frontend to be able to ask for the GPG
# password from inside evolution, bug 160302
PINENTRY_DEPEND="|| ( app-crypt/pinentry[gtk] app-crypt/pinentry-qt app-crypt/pinentry[qt4] )"

# contacts-map plugin requires libchaimplain and geoclue
# glade-3 support is for maintainers only per configure.ac
# mono plugin disabled as it's incompatible with 2.8 and lacks maintainance (see bgo#634571)
# pst is not mature enough and changes API/ABI frequently
COMMON_DEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/cairo-1.9.15[glib]
	>=x11-libs/gtk+-3.0.2:3
	>=dev-libs/libunique-2.91.4:3
	>=gnome-base/gnome-desktop-2.91.3:3
	>=dev-libs/libgweather-2.90.0:2
	>=media-libs/libcanberra-0.25[gtk3]
	>=x11-libs/libnotify-0.7
	>=gnome-extra/evolution-data-server-${PV}[weather]
	>=gnome-extra/gtkhtml-3.31.3:4.0
	>=gnome-base/gconf-2:2
	dev-libs/atk
	>=dev-libs/libxml2-2.7.3:2
	>=net-libs/libsoup-gnome-2.31.2:2.4
	>=x11-misc/shared-mime-info-0.22
	>=x11-themes/gnome-icon-theme-2.30.2.1
	>=dev-libs/libgdata-0.4

	x11-libs/libSM
	x11-libs/libICE

	clutter? (
		>=media-libs/clutter-1.0.0:1.0
		>=media-libs/clutter-gtk-0.90:1.0
		x11-libs/mx )
	connman? ( net-misc/connman )
	crypt? ( || (
		( >=app-crypt/gnupg-2.0.1-r2 ${PINENTRY_DEPEND} )
		=app-crypt/gnupg-1.4* ) )
	gstreamer? (
		>=media-libs/gstreamer-0.10:0.10
		>=media-libs/gst-plugins-base-0.10:0.10 )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2 )
	map? (
		>=app-misc/geoclue-0.11.1
		media-libs/libchamplain:0.8 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	ssl? (
		>=dev-libs/nspr-4.6.1
		>=dev-libs/nss-3.11 )"
DEPEND="${COMMON_DEPEND}
	>=dev-util/pkgconfig-0.16
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	sys-devel/bison
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.9.1
	app-text/docbook-xml-dtd:4.1.2
	>=gnome-base/gnome-common-2.12
	>=dev-util/gtk-doc-am-1.9
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	>=gnome-base/gnome-common-2.12
#	>=dev-util/gtk-doc-am-1.9
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/evolution-exchange-2.32"

# Need EAPI=4 support in python eclass
#REQUIRED_USE="map? ( clutter )
#	^^ ( connman networkmanager )"

pkg_setup() {
	ELTCONF="--reverse-deps"
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"
	# image-inline plugin needs a gtk+:3 gtkimageview, which does not exist yet
	G2CONF="${G2CONF}
		--without-glade-catalog
		--without-kde-applnk-path
		--enable-plugins=experimental
		--disable-image-inline
		--disable-mono
		--disable-profiling
		--disable-pst-import
		--enable-canberra
		--enable-weather
		$(use_enable ssl nss)
		$(use_enable ssl smime)
		$(use_enable networkmanager nm)
		$(use_enable connman)
		$(use_enable gstreamer audio-inline)
		$(use_enable map contacts-map)
		$(use_enable python)
		$(use_with clutter)
		$(use_with ldap openldap)
		$(use_with kerberos krb5 /usr)"

	# dang - I've changed this to do --enable-plugins=experimental.  This will
	# autodetect new-mail-notify and exchange, but that cannot be helped for the
	# moment.  They should be changed to depend on a --enable-<foo> like mono
	# is.  This cleans up a ton of crap from this ebuild.

	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		G2CONF="${G2CONF} --enable-nss=yes"
	else
		G2CONF="${G2CONF}
			--without-nspr-libs
			--without-nspr-includes
			--without-nss-libs
			--without-nss-includes"
	fi

	# NM and connman support cannot coexist
	# XXX: remove with EAPI 4
	if use networkmanager && use connman ; then
		ewarn "It is not possible to enable both ConnMan and NetworkManager, disabling connman..."
		G2CONF="${G2CONF} --disable-connman"
	fi

	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare

	# Fix compilation flags crazyness
	# Note: sed configure.ac if eautoreconf, conditional on [[ 9999 ]]
	sed -e 's/\(AM_CPPFLAGS="\)$WARNING_FLAGS"/\1/' \
		-i configure || die "CPPFLAGS sed failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To change the default browser if you are not using GNOME, edit"
	elog "~/.local/share/applications/mimeapps.list so it includes the"
	elog "following content:"
	elog ""
	elog "[Default Applications]"
	elog "x-scheme-handler/http=firefox.desktop"
	elog "x-scheme-handler/https=firefox.desktop"
	elog ""
	elog "(replace firefox.desktop with the name of the appropriate .desktop"
	elog "file from /usr/share/applications if you use a different browser)."
	elog ""
	elog "Junk filters are now a run-time choice. You will get a choice of"
	elog "bogofilter or spamassassin based on which you have installed"
	elog ""
	elog "You have to install one of these for the spam filtering to actually work"
}
