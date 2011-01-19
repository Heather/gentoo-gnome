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
#IUSE="doc vala"
IUSE="doc"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~sparc ~x86"
fi

RDEPEND=">=dev-libs/glib-2.25.10
	>=dev-libs/libgee-0.5.1
	>=dev-libs/libxml2-2.7.7
	sys-apps/dbus
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.11.4:0.12
	doc? ( >=dev-util/gtk-doc-1.15 )"
#vala? ( >=dev-lang/vala-0.9.5:0.10 )

src_prepare() {
	G2CONF="${G2CONF}
		VALAC=$(type -p valac-0.12)"
		#$(use_enable vala)

	# This needs eautoreconf
	# XXX: file a bug for this
	sed -e 's:^include gtk-doc.make:include $(top_srcdir)/gtk-doc.make:' \
		-i docs/Makefile.am || die "Fixing gtk-doc.make failed"

	# Fix vala automagic support, upstream bug #634171
	# FIXME: patch doesn't actually work, forcing vala support above
	#epatch "${FILESDIR}/${PN}-automagic-vala.patch"

	if [[ ${PV} != 9999 ]]; then
		gtkdocize
		eautoreconf
	fi

	gnome2_src_prepare
}
