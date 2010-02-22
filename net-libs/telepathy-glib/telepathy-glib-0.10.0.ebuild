# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/telepathy-glib/telepathy-glib-0.7.34.ebuild,v 1.1 2009/08/21 21:15:54 tester Exp $

EAPI="2"

inherit autotools eutils libtool

DESCRIPTION="GLib bindings for the Telepathy D-Bus protocol."
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc"

RDEPEND=">=dev-libs/glib-2.20
	>=dev-libs/dbus-glib-0.82
	>=dev-lang/python-2.5"

DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/pkgconfig-0.21
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.10 )"

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable debug) \
		$(use_enable debug backtrace) \
		$(use_enable debug handle-leak-debug) \
		|| die "econf failed"
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
