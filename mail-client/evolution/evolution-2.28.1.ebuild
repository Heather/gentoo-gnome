# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/evolution/evolution-2.26.3.ebuild,v 1.4 2009/09/09 19:34:01 mrpouet Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools gnome2 flag-o-matic python

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="GPL-2 FDL-1.1"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc64 ~x86"
IUSE="crypt dbus hal kerberos krb4 ldap mono networkmanager nntp pda profile python ssl gstreamer exchange"
# pst

# Pango dependency required to avoid font rendering problems
# We need a graphical pinentry frontend to be able to ask for the GPG
# password from inside evolution, bug 160302
RDEPEND=">=dev-libs/glib-2.20
	>=x11-libs/gtk+-2.16
	>=gnome-extra/evolution-data-server-2.26.3
	>=x11-themes/gnome-icon-theme-2.20
	>=gnome-base/libbonobo-2.20.3
	>=gnome-base/libbonoboui-2.4.2
	>=gnome-extra/gtkhtml-3.27.90
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/libgnomeui-2
	>=dev-libs/libxml2-2.7.3
	>=dev-libs/libgweather-2.25.3
	>=x11-misc/shared-mime-info-0.22
	>=gnome-base/gnome-desktop-2.26.0
	dbus? ( >=dev-libs/dbus-glib-0.74 )
	hal? ( >=sys-apps/hal-0.5.4 )
	x11-libs/libnotify
	pda? (
		>=app-pda/gnome-pilot-2.0.15
		>=app-pda/gnome-pilot-conduits-2 )
	dev-libs/atk
	ssl? (
		>=dev-libs/nspr-4.6.1
		>=dev-libs/nss-3.11 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	>=net-libs/libsoup-2.4
	kerberos? ( virtual/krb5 )
	krb4? ( app-crypt/mit-krb5[krb4] )
	>=gnome-base/orbit-2.9.8
	crypt? ( || (
				  ( >=app-crypt/gnupg-2.0.1-r2
					|| ( app-crypt/pinentry[gtk] app-crypt/pinentry[qt3] ) )
				  =app-crypt/gnupg-1.4* ) )
	ldap? ( >=net-nds/openldap-2 )
	mono? ( >=dev-lang/mono-1 )
	python? ( >=dev-lang/python-2.4 )
	gstreamer? (
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10 )"
# Disabled until API stabilizes
#	pst? ( >=net-mail/libpst-0.6.41 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.16
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	sys-devel/bison
	app-text/scrollkeeper
	>=gnome-base/gnome-common-2.12.0
	>=app-text/gnome-doc-utils-0.9.1"

PDEPEND="exchange? ( >=gnome-extra/evolution-exchange-2.26.1 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"
ELTCONF="--reverse-deps"

pkg_setup() {
	G2CONF="${G2CONF}
		--without-kde-applnk-path
		--enable-plugins=experimental
		--with-weather
		$(use_enable ssl nss)
		$(use_enable ssl smime)
		$(use_enable mono)
		$(use_enable nntp)
		$(use_enable networkmanager nm)
		$(use_enable dbus)
		$(use_enable gstreamer audio-inline)
		$(use_enable exchange)
		--disable-pst-import
		$(use_enable pda pilot-conduits)
		$(use_enable profile profiling)
		$(use_enable python)
		$(use_with ldap openldap)
		$(use_with kerberos krb5 /usr)
		$(use_with krb4 krb4 /usr)"

	# dang - I've changed this to do --enable-plugins=experimental.  This will
	# autodetect new-mail-notify and exchange, but that cannot be helped for the
	# moment.  They should be changed to depend on a --enable-<foo> like mono
	# is.  This cleans up a ton of crap from this ebuild.
}

src_prepare() {
	gnome2_src_prepare

	# Fix timezone offsets on fbsd.  bug #183708
	# FIXME: bsd needs to be more active at pushing stuff upstream
	#epatch "${FILESDIR}/${PN}-2.21.3-fbsd.patch"

	# Fix delete keyboard shortcut, bug #????
	epatch "${FILESDIR}/${PN}-2.28.0-delete-key.patch"

	# Fix multiple automagic plugins, bug #204300 & bug #271451
	epatch "${FILESDIR}/${PN}-2.28.0-automagic-plugins.patch"

	# FIXME: Fix compilation flags crazyness
	sed 's/CFLAGS="$CFLAGS $WARNING_FLAGS"//' \
		-i configure.ac configure || die "sed 1 failed"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		sed -i -e "s|mozilla-nss|nss|
			s|mozilla-nspr|nspr|" "${S}"/configure || die "sed 1 failed"
		G2CONF="${G2CONF} --enable-nss=yes"
	else
		G2CONF="${G2CONF} --without-nspr-libs --without-nspr-includes \
			--without-nss-libs --without-nss-includes"
	fi

	# problems with -O3 on gcc-3.3.1
	replace-flags -O3 -O2
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
