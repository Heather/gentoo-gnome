# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/evolution/evolution-2.32.1-r1.ebuild,v 1.3 2011/01/15 19:56:39 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="python? 2:2.4"

inherit autotools flag-o-matic gnome2 python versionator

MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="GPL-2 LGPL-2 OPENLDAP"
SLOT="2.0"
IUSE="clutter connman crypt doc gstreamer kerberos ldap networkmanager python ssl"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

# We need a graphical pinentry frontend to be able to ask for the GPG
# password from inside evolution, bug 160302
PINENTRY_DEPEND="|| ( app-crypt/pinentry[gtk] app-crypt/pinentry-qt app-crypt/pinentry[qt4] )"

# contacts-map plugin requires libchaimplain and geoclue
# glade-3 support is for maintainers only per configure.ac
# mono plugin disabled as it's incompatible with 2.8 and lacks maintainance (see bgo#634571)
# pst is not mature enough and changes API/ABI frequently
RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/cairo-1.9.15
	>=x11-libs/gtk+-3.0:3
	>=dev-libs/libunique-2.91.4:3
	>=gnome-base/gnome-desktop-2.91.3:3
	>=dev-libs/libgweather-2.90.0:3
	media-libs/libcanberra[gtk3]
	>=x11-libs/libnotify-0.7
	>=gnome-extra/evolution-data-server-${MY_MAJORV}[weather]
	>=gnome-extra/gtkhtml-3.31.3:4.0
	>=gnome-base/gconf-2
	dev-libs/atk
	>=dev-libs/libxml2-2.7.3
	>=net-libs/libsoup-gnome-2.4:2.4
	>=x11-misc/shared-mime-info-0.22
	>=x11-themes/gnome-icon-theme-2.30.2.1
	>=dev-libs/libgdata-0.4

	clutter? (
		>=media-libs/clutter-1.0.0:1.0[gtk]
		>=media-libs/clutter-gtk-0.90:1.0
		x11-libs/mx )
	connman? ( net-misc/connman )
	crypt? ( || (
				  ( >=app-crypt/gnupg-2.0.1-r2
					${PINENTRY_DEPEND} )
				  =app-crypt/gnupg-1.4* ) )
	gstreamer? (
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10 )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	ssl? (
		>=dev-libs/nspr-4.6.1
		>=dev-libs/nss-3.11 )

	!<gnome-extra/evolution-exchange-2.32"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.16
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
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

pkg_setup() {
	ELTCONF="--reverse-deps"
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"
	G2CONF="${G2CONF}
		--without-kde-applnk-path
		--enable-plugins=experimental
		--disable-image-inline
		--enable-canberra
		--enable-weather
		$(use_enable ssl nss)
		$(use_enable ssl smime)
		$(use_enable networkmanager nm)
		$(use_enable connman)
		$(use_enable gstreamer audio-inline)
		--disable-profiling
		--disable-pst-import
		$(use_enable python)
		$(use_with clutter)
		$(use_with ldap openldap)
		$(use_with kerberos krb5 /usr)
		--disable-contacts-map
		--without-glade-catalog
		--disable-mono"
	# image-inline plugin needs a gtk+:3 gtkimageview, which does not exist yet

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
	if use networkmanager && use connman ; then
		ewarn "It is not possible to enable both ConnMan and NetworkManager, disabling connman..."
		G2CONF="${G2CONF} --disable-connman"
	fi

	python_set_active_version 2
}

src_prepare() {
	# Fix invalid use of la file in contact-editor, upstream bug #635002
	epatch "${FILESDIR}/${PN}-2.32.0-wrong-lafile-usage.patch"

	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		sed -e 's|mozilla-nss|nss|' \
			-e 's|mozilla-nspr|nspr|' \
			-i configure.ac || die "sed 2 failed"
	fi

	# Fix compilation flags crazyness
	sed -e 's/CFLAGS="$CFLAGS $WARNING_FLAGS"//' \
		-i configure.ac || die "sed 1 failed"

	if [[ ${PV} != 9999 ]]; then
		intltoolize --force --copy --automake || die "intltoolize failed"
		eautoreconf
	fi

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To change the default browser if you are not using GNOME, do:"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/http/command -t string 'firefox %s'"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/https/command -t string 'firefox %s'"
	elog ""
	elog "Replace 'firefox %s' with which ever browser you use."
	elog ""
	elog "Junk filters are now a run-time choice. You will get a choice of"
	elog "bogofilter or spamassassin based on which you have installed"
	elog ""
	elog "You have to install one of these for the spam filtering to actually work"
}
