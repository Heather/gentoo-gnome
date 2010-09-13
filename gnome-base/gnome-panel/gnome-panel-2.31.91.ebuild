# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="The GNOME panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc eds introspection networkmanager"

RDEPEND="dev-lang/python
	>=gnome-base/gnome-desktop-2.24.0
	>=x11-libs/pango-1.15.4
	>=dev-libs/glib-2.25.12
	>=x11-libs/gtk+-2.19.7
	>=dev-libs/libgweather-2.27.90
	dev-libs/libxml2
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/orbit-2.4
	>=x11-libs/libwnck-2.19.5
	>=gnome-base/gconf-2.6.1
	>=media-libs/libcanberra-0.23[gtk]
	>=gnome-base/gnome-menus-2.27.92
	>=gnome-base/libbonobo-2.20.4
	gnome-base/librsvg
	>=dev-libs/dbus-glib-0.80
	>=sys-apps/dbus-1.1.2
	>=x11-libs/cairo-1
	x11-libs/libXau
	>=x11-libs/libXrandr-1.2
	eds? ( >=gnome-extra/evolution-data-server-1.6 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	networkmanager? ( >=net-misc/networkmanager-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )"
# eautoreconf needs
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-deprecations
		--disable-static
		--disable-scrollkeeper
		--disable-schemas-install
		--with-in-process-applets=clock,notification-area,wncklet
		$(use_enable networkmanager network-manager)
		$(use_enable introspection)
		$(use_enable eds)"
}

pkg_postinst() {
	local entries="${EROOT}etc/gconf/schemas/panel-default-setup.entries"
	local gconftool="${EROOT}usr/bin/gconftool-2"

	if [ -e "$entries" ]; then
		einfo "setting panel gconf defaults..."

		GCONF_CONFIG_SOURCE="$("${gconftool}" --get-default-source | sed "s;:/;:${ROOT};")"

		"${gconftool}" --direct --config-source \
			"${GCONF_CONFIG_SOURCE}" --load="${entries}"
	fi

	# Calling this late so it doesn't process the GConf schemas file we already
	# took care of.
	gnome2_pkg_postinst
}
