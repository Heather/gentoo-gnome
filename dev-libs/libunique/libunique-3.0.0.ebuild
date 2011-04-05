# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libunique/libunique-1.1.6.ebuild,v 1.5 2010/06/20 11:27:08 nirbheek Exp $

EAPI="3"
GCONF_DEBUF="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx

DESCRIPTION="a library for writing single instance application"
HOMEPAGE="http://live.gnome.org/LibUnique"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="doc +introspection"

RDEPEND=">=dev-libs/glib-2.25.7:2
	>=x11-libs/gtk+-2.90.0:3[introspection?]
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1.13 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )"
# For eautoreconf
#	dev-util/gtk-doc-am

pkg_setup() {
	DOCS="AUTHORS NEWS ChangeLog README TODO"
	# --disable-dbus means gdbus is used instead of dbus-glib
	G2CONF="${G2CONF}
		--disable-static
		--disable-maintainer-flags
		--disable-dbus
		$(use_enable introspection)"
}

src_test() {
	cd "${S}/tests"

	# Fix environment variable leakage (due to `su` etc)
	unset DBUS_SESSION_BUS_ADDRESS

	# Force Xemake to use Xvfb, bug 279840
	unset XAUTHORITY
	unset DISPLAY

	cp "${FILESDIR}/run-tests" . || die "Unable to cp \${FILESDIR}/run-tests"
	Xemake -f run-tests || die "Tests failed"
}
