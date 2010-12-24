# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="http://live.gnome.org/dconf"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"
IUSE="doc vala"

RDEPEND=">=dev-libs/glib-2.25.10
	>=dev-libs/libgee-0.5.1
	>=dev-libs/libxml2-2.7.7
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	vala? ( >=dev-lang/vala-0.9.5:0.10 )
	doc? ( >=dev-util/gtk-doc-1.15 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable vala)
		VALAC=$(type -p valac-0.10)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix vala automagic support, upstream bug #634171
	epatch "${FILESDIR}/${PN}-0.5.1-automagic-vala.patch"

	AT_M4DIR=. eautoreconf
}
