# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2"

inherit autotools eutils gnome2 python

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"
# XXX: Temporary SRC_URI for git snapshot (to build w/ latest xul-2 snapshot)
SRC_URI="mirror://gentoo/${P}_e5096b09.tar.bz2"

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
IUSE="coverage examples"

if [[ ${PV} == 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND=">=dev-libs/glib-2.18:2
	>=dev-libs/gobject-introspection-0.9.5

	dev-libs/dbus-glib
	x11-libs/cairo
	>=net-libs/xulrunner-1.9.2:1.9"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	coverage? (
		sys-devel/gcc
		dev-util/lcov )"

# tests fail and upstream does not support anything but git master
RESTRICT="test"

src_prepare() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"
	G2CONF="${G2CONF}
		$(use_enable coverage)"

	# Needs trunk gtk+/glib/g-i
	epatch "${FILESDIR}/${P}-revert-gunichar.patch"

	# Needs trunk glib/g-i
	epatch "${FILESDIR}/${P}-revert-use-g_object_info_find_method_using_interface.patch"

	# Needs trunk g-i
	epatch "${FILESDIR}/${P}-revert-support-signals-with-G_TYPE_POINTER-argument.patch"

	gnome2_src_prepare
	python_convert_shebangs 2 "${S}"/scripts/make-tests

	# Needed because it's a git snapshot
	eautoreconf
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins ${S}/examples/* || die "doins examples failed!"
	fi

	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
