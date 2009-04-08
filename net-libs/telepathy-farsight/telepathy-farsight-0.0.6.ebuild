# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

DESCRIPTION="Farsight connection manager for the Telepathy framework"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.60
	>=net-libs/telepathy-glib-0.7.23
	>=net-libs/farsight2-0.0.8
	python? (
		>=dev-python/pygobject-2.12.0
		>=dev-python/pygtk-2.10
		>=dev-python/gst-python-0.10.10
		)"

DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable python)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NEWS ChangeLog
}
