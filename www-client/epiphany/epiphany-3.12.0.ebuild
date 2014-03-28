# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit eutils gnome2 pax-utils versionator virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="http://projects.gnome.org/epiphany/"

# TODO: coverage
LICENSE="GPL-2"
SLOT="0"
IUSE="+nss test"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=app-crypt/libsecret-0.14
	>=app-crypt/gcr-3.5.5
	>=app-text/iso-codes-0.35
	>=dev-libs/glib-2.38.0:2
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=net-dns/avahi-0.6.22
	>=net-libs/webkit-gtk-2.4.0:3
	>=net-libs/libsoup-2.42.1:2.4
	>=x11-libs/gtk+-3.11.6:3
	>=x11-libs/libnotify-0.5.1:=
	gnome-base/gnome-desktop:3=

	dev-db/sqlite:3
	x11-libs/libwnck
	x11-libs/libX11

	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic

	nss? ( dev-libs/nss )
"
# paxctl needed for bug #407085
# eautoreconf requires gnome-common-3.5.5
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50
	sys-apps/paxctl
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--enable-shared \
		--disable-static \
		--with-distributor-name=Gentoo \
		$(use_enable nss) \
		$(use_enable test tests)
}

src_compile() {
	# needed to avoid "Command line `dbus-launch ...' exited with non-zero exit status 1"
	unset DISPLAY
	gnome2_src_compile
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}

src_install() {
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"
	gnome2_src_install
}
