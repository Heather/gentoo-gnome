# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit eutils

DESCRIPTION="Farsight connection manager for the Telepathy framework"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug python"

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.60
	>=net-libs/telepathy-glib-0.7.8
	>=net-voip/farsight2-0.0.3
	python? (
		>=dev-python/pygobject-2.12.0
		>=dev-python/pygtk-2.10
		>=dev-python/gst-python-0.10.10
		)"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

src_configure() {
	econf --disable-coverage
		$(use_enable python) \
		$(use_enable debug Werror) \
		$(use_enable doc gtk-doc)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NEWS ChangeLog
}
