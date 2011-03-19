# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gtk-vnc/gtk-vnc-0.4.2-r2.ebuild,v 1.1 2011/01/14 23:03:42 cardoe Exp $

EAPI="2"

inherit base gnome.org

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="http://live.gnome.org/gtk-vnc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples +introspection sasl"

# libview is used in examples/gvncviewer -- no need
# TODO: review nsplugin when it will be considered less experimental

RDEPEND=">=dev-libs/glib-2.10:2
	>=net-libs/gnutls-1.4
	>=x11-libs/cairo-1.2
	>=x11-libs/gtk+-2.91.3:3
	x11-libs/libX11
	introspection? ( >=dev-libs/gobject-introspection-0.9.4 )
	sasl? ( dev-libs/cyrus-sasl )
	
	!!net-libs/gtk-vnc:3"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40"

src_configure() {
	# Python support is via gobject-introspection
	# Ex: from gi.repository import GtkVnc
	econf \
		$(use_with examples) \
		$(use_enable introspection) \
		$(use_with sasl) \
		--with-python=no \
		--with-coroutine=gthread \
		--without-libview \
		--with-gtk=3.0 \
		--disable-static
}

src_install() {
	# bug #328273
	MAKEOPTS="${MAKEOPTS} -j1" \
		base_src_install
	dodoc AUTHORS ChangeLog NEWS README || die

	# Remove .la files
	find "${D}" -name '*.la' -exec rm -f '{}' + || die
}
