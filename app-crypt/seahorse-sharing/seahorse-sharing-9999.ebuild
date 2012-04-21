# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Daemon for PGP public key sharing using DNS-SD and HKP"
HOMEPAGE="http://projects.gnome.org/seahorse/"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE=""

COMMON_DEPEND="dev-libs/glib:2
	>=net-dns/avahi-0.6
	net-libs/libsoup:2.4
	>=x11-libs/gtk+-3:3

	>=app-crypt/gpgme-1
	|| (
		=app-crypt/gnupg-2.0*
		=app-crypt/gnupg-1.4* )"
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-3.2"
# ${PN} was part of seahorse before 3.2
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	DOCS="AUTHORS MAINTAINERS NEWS" # ChangeLog has nothing useful
	# Do not pass --enable-tests to configure - package has no tests
}

src_prepare() {
	gnome2_src_prepare
	# Avoid eautoreconf
	sed -e 's:$CFLAGS -g -O0:$CFLAGS:' -i configure || die "sed failed"
}

pkg_postinst() {
	elog "To use ${PN}, the Avahi daemon must be running. On an OpenRC"
	elog "system, you can start the Avahi daemon by"
	elog "# /etc/init.d/avahi-daemon start"
	elog "To start Avahi automatically, add it to the default runlevel:"
	elog "# rc-update add avahi-daemon default"
}
