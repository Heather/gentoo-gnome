# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/seed/seed-2.30.0.ebuild,v 1.1 2010/06/29 08:27:36 nirbheek Exp $

EAPI="2"
WANT_AUTOMAKE="1.11"
inherit autotools gnome2

DESCRIPTION="Javascript bindings for Webkit-GTK and GNOME libraries"
HOMEPAGE="http://live.gnome.org/Seed"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus debug doc mpfr profile +sqlite test +xml"

RDEPEND="
	>=dev-libs/gobject-introspection-0.9

	dev-libs/glib
	virtual/libffi
	x11-libs/cairo
	x11-libs/gtk+:2[introspection]
	net-libs/webkit-gtk:3.0
	gnome-base/gnome-js-common

	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib )
	mpfr? ( dev-libs/mpfr )
	profile? ( sys-devel/gcc )
	sqlite? ( dev-db/sqlite:3 )
	xml? ( dev-libs/libxml2:2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-0.9 )"

DOCS="AUTHORS ChangeLog NEWS README"
# FIXME: tests need all the feature-USE-flags enabled to complete successfully
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable dbus dbus-module)
		$(use_enable mpfr mpfr-module)
		$(use_enable sqlite sqlite-module)
		$(use_enable xml libxml-module)"

	# configure behaves very strangely and enables profiling if we pass either
	# --disable-profile or --enable-profile
	if use profile; then
		G2CONF="${G2CONF}
			--enable-profile
			--enable-profile-modules"
		if ! use debug; then
			elog "USE=profile needs debug, auto-enabling..."
			G2CONF="${G2CONF} --enable-debug"
		fi
	fi

	if use profile && has ccache ${FEATURES}; then
		ewarn "USE=profile behaves very badly with ccache; it tries to create"
		ewarn "profiling data in CCACHE_DIR. Please disable one of them!"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cleanup-autotools.patch

	intltoolize --automake --copy --force || die "intltoolize failed"
	eautoreconf
}
