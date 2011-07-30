# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gjs/gjs-0.7.14.ebuild,v 1.2 2011/05/01 15:42:03 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit autotools eutils gnome2 python virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
IUSE="examples test +xulrunner"
KEYWORDS="~amd64 ~x86"

# Things are untested and broken with anything other than xulrunner-2.0
# FIXME: https://bugzilla.mozilla.org/show_bug.cgi?id=628723 instead of libxul
RDEPEND=">=dev-libs/glib-2.18:2
	>=dev-libs/gobject-introspection-0.10.1
	>=net-libs/xulrunner-2.0:1.9

	dev-libs/dbus-glib
	sys-libs/readline
	x11-libs/cairo
	xulrunner? (
		>=net-libs/xulrunner-2.0:1.9
		!=dev-lang/spidermonkey-1.8.2* )
	!xulrunner? ( =dev-lang/spidermonkey-1.8.5* )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9"
# HACK HACK: gjs-tests picks up /usr/lib/libmozjs.so with spidermonkey installed

src_prepare() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"
	# FIXME: add systemtap/dtrace support, like in glib:2
	# XXX: Do NOT enable coverage, completely useless for portage installs
	G2CONF="${G2CONF}
		--disable-systemtap
		--disable-dtrace
		--disable-coverage"
	if use xulrunner; then
		G2CONF="${G2CONF} --with-js-package=mozilla-js"
	else
		G2CONF="${G2CONF} --with-js-package=mozjs185"
	fi

	# https://bugzilla.gnome.org/show_bug.cgi?id=646369
	# https://bugs.gentoo.org/353941
	# https://bugzilla.gnome.org/show_bug.cgi?id=655479
	epatch "${FILESDIR}/${P}-sanity.patch"

	eautoreconf

	gnome2_src_prepare
	python_convert_shebangs 2 "${S}"/scripts/make-tests
}

src_test() {
	# Tests need dbus
	Xemake check || die
}

src_install() {
	# installation sometimes fails in parallel
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/* || die "doins examples failed!"
	fi
}
