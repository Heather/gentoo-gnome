# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gjs/gjs-1.29.0.ebuild,v 1.1 2011/06/14 13:19:59 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit autotools eutils gnome2 python virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
IUSE="examples spidermonkey test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# Things are untested and broken with anything other than xulrunner-2.0
# or spidermonkey-1.8.5
RDEPEND=">=dev-libs/glib-2.18:2
	>=dev-libs/gobject-introspection-1.29.15

	dev-libs/dbus-glib
	sys-libs/readline
	x11-libs/cairo
	spidermonkey? ( =dev-lang/spidermonkey-1.8.5* )
	!spidermonkey? ( >=net-libs/xulrunner-2.0:1.9 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	!<dev-lang/spidermonkey-1.8.5"
# HACK HACK: gjs-tests picks up /usr/lib/libmozjs.so with old spidermonkey installed

pkg_setup() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	# XXX: Do NOT enable coverage, completely useless for portage installs
	G2CONF="${G2CONF}
		--disable-systemtap
		--disable-dtrace
		--disable-coverage"
	if use spidermonkey; then
		G2CONF="${G2CONF} --with-js-package=mozjs185"
	else
		G2CONF="${G2CONF} --with-js-package=mozilla-js"
	fi
}

src_prepare() {
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
		doins ${S}/examples/* || die "doins examples failed!"
	fi
}
