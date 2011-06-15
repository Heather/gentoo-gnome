# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="3"
IUSE="doc +introspection"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
fi

# TODO: Add RDEPEND on pciutils (requires support for reading gzipped pnp.ids)
# Latest schemas needed due to commit 7f3e3d52
RDEPEND="
	>=dev-libs/glib-2.19.1:2
	>=x11-libs/gdk-pixbuf-2.21.3:2[introspection?]
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=x11-libs/libXrandr-1.2
	>=x11-libs/startup-notification-0.5
	x11-libs/libX11
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	doc? ( !<gnome-base/gnome-desktop-2.32.1-r50:2[doc] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.7 )"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext
	x11-proto/xproto
	>=x11-proto/randrproto-1.2
	doc? ( >=dev-util/gtk-doc-1.4 )"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-static
		--with-pnp-ids-path=internal
		--with-gnome-distributor=Gentoo
		$(use_enable doc desktop-docs)
		$(use_enable introspection)"
}
