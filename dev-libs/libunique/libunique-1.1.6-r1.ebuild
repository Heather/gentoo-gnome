# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libunique/libunique-1.1.6.ebuild,v 1.17 2011/04/24 17:05:44 nirbheek Exp $

EAPI="2"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="a library for writing single instance application"
HOMEPAGE="http://live.gnome.org/LibUnique"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="dbus doc +introspection"

RDEPEND=">=dev-libs/glib-2.12:2
	>=x11-libs/gtk+-2.11:2[introspection?]
	x11-libs/libX11
	dbus? ( >=dev-libs/dbus-glib-0.70 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1.11 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"
# For eautoreconf
#	dev-util/gtk-doc-am

DOCS="AUTHORS NEWS ChangeLog README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-flags
		--disable-static
		--enable-bacon
		$(use_enable introspection)
		$(use_enable dbus)"
}

src_prepare() {
	# Fixes an off-by-one g_memdup error; will be in next release
	epatch "${FILESDIR}/${P}-unique_message_data_get_filename-off-by-1.patch"

	# Removes G_CONST_RETURN for compatibility with >=glib-2.29
	# https://bugzilla.gnome.org/show_bug.cgi?id=652545
	epatch "${FILESDIR}/${P}-G_CONST_RETURN.patch"

	gnome2_src_prepare
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
