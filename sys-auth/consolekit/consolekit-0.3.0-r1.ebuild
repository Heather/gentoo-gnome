# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/consolekit/consolekit-0.2.10.ebuild,v 1.1 2008/06/21 20:38:24 yngwin Exp $

inherit eutils autotools multilib pam

MY_PN="ConsoleKit"
MY_PV="${PV//_pre*/}"

DESCRIPTION="Framework for defining and tracking users, login sessions and seats."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/ConsoleKit"
SRC_URI="http://people.freedesktop.org/~mccann/dist/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"
IUSE="debug pam policykit"

RDEPEND=">=dev-libs/glib-2.7
	>=dev-libs/dbus-glib-0.61
	>=x11-libs/libX11-1.0.0
	pam? ( virtual/pam )
	policykit? ( >=sys-auth/policykit-0.7 )
	elibc_glibc? ( !=sys-libs/glibc-2.4* )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-libs/libxslt"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Work around an apparent FreeBSD kernel bug
	use x86-fbsd && epatch "${FILESDIR}/${PN}"-0.2.3-freebsd.patch

	# Fix policykit automagic dependency
	epatch "${FILESDIR}/${PN}-0.2.10-polkit-automagic.patch"

	# Fix inability to shutdown/restart
	epatch "${FILESDIR}/${P}-shutdown.patch"

	eautoreconf
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable policykit polkit) \
		$(use_enable pam pam-module) \
		--with-pam-module-dir=/$(getpam_mod_dir) \
		--with-pid-file=/var/run/consolekit.pid \
		--with-dbus-services=/usr/share/dbus-1/services/
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# crappy Redhat init script
	rm -f "${D}/etc/rc.d/init.d/ConsoleKit"
	rm -r "${D}/etc/rc.d/"

	# Portage barfs on .la files
	rm -f "${D}/$(get_libdir)/security/pam_ck_connector.la"

	# Gentoo style init script
	newinitd "${FILESDIR}"/${PN}-0.1.rc consolekit
}

pkg_postinst() {
	ewarn
	ewarn "You need to restart ConsoleKit to get the new features."
	ewarn "This can be done with /etc/init.d/consolekit restart"
	ewarn "but make sure you do this and then restart your session"
	ewarn "otherwise you will get access denied for certain actions"
	ewarn
}
