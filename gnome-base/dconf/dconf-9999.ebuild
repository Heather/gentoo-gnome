# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="http://live.gnome.org/dconf"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc vala"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~sparc ~x86"
fi

RDEPEND=">=dev-libs/glib-2.25.16
	>=dev-libs/libgee-0.5.1
	>=dev-libs/libxml2-2.7.7
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	vala? ( >=dev-lang/vala-0.11.4:0.11 )
	doc? ( >=dev-util/gtk-doc-1.15 )"

src_prepare() {
	G2CONF="${G2CONF}
		$(use_enable vala)
		VALAC=$(type -p valac-0.12)"

	# This needs eautoreconf
	sed -e 's:^include gtk-doc.make:include $(top_srcdir)/gtk-doc.make:g' \
		-i docs/Makefile.am || die "Fixing gtk-doc.make failed"

	# Fix vala automagic support, upstream bug #634171
	epatch "${FILESDIR}/${PN}-automagic-vala.patch"

	[[ ${PV} != 9999 ]] && AT_M4DIR=. eautoreconf

	gnome2_src_prepare
}
