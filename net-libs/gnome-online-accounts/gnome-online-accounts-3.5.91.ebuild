# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://live.gnome.org/GnomeOnlineAccounts"

LICENSE="LGPL-2"
SLOT="0"
IUSE="doc gnome +introspection kerberos"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# pango used in goaeditablelabel
# libsoup used in goaoauthprovider
RDEPEND="
	>=dev-libs/glib-2.32:2
	app-crypt/libsecret
	dev-libs/json-glib
	dev-libs/libxml2:2
	net-libs/libsoup:2.4
	>=net-libs/libsoup-gnome-2.38:2.4
	net-libs/rest:0.7
	net-libs/webkit-gtk:3
	>=x11-libs/gtk+-3.5.1:3
	>=x11-libs/libnotify-0.7
	x11-libs/pango

	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )
	kerberos? (
		app-crypt/gcr
		virtual/krb5 )"
# goa-daemon can launch gnome-control-center
PDEPEND="gnome? ( >=gnome-base/gnome-control-center-3.2[gnome-online-accounts(+)] )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.30.0
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig

	doc? ( >=dev-util/gtk-doc-1.3 )"

pkg_setup() {
	# TODO: Give users a way to set the G/Y!/FB/Twitter/Windows Live secrets
	G2CONF="${G2CONF}
		--disable-static
		--enable-documentation
		--enable-exchange
		--enable-facebook
		--enable-windows-live
		$(use_enable kerberos)"
	DOCS="NEWS" # README is empty
}
