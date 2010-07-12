# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="GLib bindings for the Telepathy D-Bus protocol."
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
# vala - needs bumping in portage
IUSE="debug introspection"

RDEPEND=">=dev-libs/glib-2.24
	>=dev-libs/dbus-glib-0.82
	>=dev-lang/python-2.5"

DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-1.15
	>=dev-util/pkgconfig-0.21
	introspection? ( >=dev-libs/gobject-introspection-0.6.14 )"
#	vala? ( >=dev-lang/vala-0.9.x )

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable debug backtrace) \
		$(use_enable debug handle-leak-debug) \
		$(use_enable introspection)
#		$(use_enable vala)
}

src_test() {
	if ! dbus-launch emake -j1 check; then
		die "Make check failed. See above for details."
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
