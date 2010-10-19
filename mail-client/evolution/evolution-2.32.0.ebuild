# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"
PYTHON_DEPEND="python? 2:2.4"

inherit autotools flag-o-matic gnome2 python versionator

MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="GPL-2 LGPL-2 OPENLDAP"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="crypt doc gstreamer gtk3 kerberos ldap networkmanager profile python ssl"
# pst
# mono - disabled because it just crashes on startup :S

# Pango dependency required to avoid font rendering problems
# We need a graphical pinentry frontend to be able to ask for the GPG.
# Note that separate pinenetry-qt is actually newer than USE=qt4 in pinentry.
# password from inside evolution, bug 160302
PINENTRY_DEPEND="|| ( app-crypt/pinentry[gtk] app-crypt/pinentry-qt app-crypt/pinentry[qt4] app-crypt/pinentry[qt3] )"

# TODO: gtk3 support might be still missing some deps (clutter)
# TODO: enable champlain support
# TODO: enable glade-3 support
RDEPEND=">=dev-libs/glib-2.25.12:2
	!gtk3? (
		>=x11-libs/gtk+-2.20:2
		>=dev-libs/libunique-1.1.2
		>=gnome-base/gnome-desktop-2.26
		>=dev-libs/libgweather-2.25.3 )
	gtk3? (
		>=x11-libs/gtk+-2.90.4:3
		>=dev-libs/libunique-2.90
		>=dev-libs/libgweather-2.90
		>=gnome-base/gnome-desktop-2.90 )
	>=gnome-extra/evolution-data-server-${MY_MAJORV}[weather,gtk3?]
	>=gnome-extra/gtkhtml-3.31.90
	>=gnome-base/gconf-2
	>=gnome-base/libgnomecanvas-2
	dev-libs/atk
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/libxml2-2.7.3
	>=net-libs/libsoup-2.4:2.4
	>=media-gfx/gtkimageview-1.6
	media-libs/libcanberra[gtk,gtk3?]
	>=x11-libs/libnotify-0.5.1[gtk3?]
	>=x11-misc/shared-mime-info-0.22
	>=x11-themes/gnome-icon-theme-2.30.2.1

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
# champlain, geoclue, clutter, gtkimageview
#	mono? ( >=dev-lang/mono-1 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.16
	>=dev-util/intltool-0.35.5
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


DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"
ELTCONF="--reverse-deps"

pkg_setup() {
	G2CONF="${G2CONF}
		--without-kde-applnk-path
		--enable-plugins=experimental
		--enable-image-inline
		--enable-canberra
		--enable-weather
		$(use_enable gtk3)
		$(use_enable ssl nss)
		$(use_enable ssl smime)
		$(use_enable networkmanager nm)
		$(use_enable gstreamer audio-inline)
		--disable-pst-import
		$(use_enable profile profiling)
		$(use_enable python)
		$(use_with ldap openldap)
		$(use_with kerberos krb5 /usr)
		--disable-contacts-map"

#		$(use_enable mono)

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

	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare

	# Fix invalid use of la file in contact-editor
	epatch "${FILESDIR}/${PN}-2.32.0-wrong-lafile-usage.patch"

	# FIXME: Fix compilation flags crazyness
	sed -e 's/CFLAGS="$CFLAGS $WARNING_FLAGS"//' \
		-i configure.ac configure || die "sed 1 failed"

	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		sed -e 's|mozilla-nss|nss|' \
			-e 's|mozilla-nspr|nspr|' \
			-i configure.ac configure || die "sed 2 failed"
	fi

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	gnome2_src_install

	find "${ED}"/usr/$(get_libdir)/evolution/${MY_MAJORV}/plugins \
		-name "*.la" -delete || die "la files removal failed 1"
	find "${ED}"/usr/$(get_libdir)/evolution/${MY_MAJORV}/modules \
		-name "*.la" -delete || die "la files removal failed 2"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To change the default browser if you are not using GNOME, do:"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/http/command -t string 'mozilla %s'"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/https/command -t string 'mozilla %s'"
	elog ""
	elog "Replace 'mozilla %s' with which ever browser you use."
	elog ""
	elog "Junk filters are now a run-time choice. You will get a choice of"
	elog "bogofilter or spamassassin based on which you have installed"
	elog ""
	elog "You have to install one of these for the spam filtering to actually work"
}
