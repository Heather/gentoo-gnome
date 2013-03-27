# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://live.gnome.org/GnomeOnlineAccounts"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="gnome +introspection kerberos"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

# pango used in goaeditablelabel
# libsoup used in goaoauthprovider
# goa kerberos provider is incompatible with app-crypt/heimdal, see
# https://bugzilla.gnome.org/show_bug.cgi?id=692250
RDEPEND="
	>=dev-libs/glib-2.35:2
	app-crypt/libsecret
	dev-libs/json-glib
	dev-libs/libxml2:2
	net-libs/libsoup:2.4
	>=net-libs/libsoup-gnome-2.41:2.4
	net-libs/rest:0.7
	net-libs/webkit-gtk:3
	>=x11-libs/gtk+-3.5.1:3
	x11-libs/pango

	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )
	kerberos? (
		app-crypt/gcr
		app-crypt/mit-krb5 )
"
# goa-daemon can launch gnome-control-center
PDEPEND="gnome? ( >=gnome-base/gnome-control-center-3.2[gnome-online-accounts(+)] )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.3
	>=dev-util/gdbus-codegen-2.30.0
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		doc? ( >=dev-util/gtk-doc-1.3 )"
fi

src_configure() {
	# TODO: Give users a way to set the G/FB/Windows Live secrets
	gnome2_src_configure \
		--disable-static \
		--enable-documentation \
		--enable-flickr \
		$(use_enable kerberos)
}
