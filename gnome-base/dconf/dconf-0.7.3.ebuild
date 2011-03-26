# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

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

COMMON_DEPEND=">=dev-libs/glib-2.27.2
	>=dev-libs/libgee-0.5.1
	>=dev-libs/libxml2-2.7.7
	sys-apps/dbus
	x11-libs/gtk+:3"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/vala-0.11.7:0.12
	doc? ( >=dev-util/gtk-doc-1.15 )"
#vala? ( >=dev-lang/vala-0.9.5:0.10 )
RDEPEND="${COMMON_DEPEND}
	!dev-lang/vala:0"

src_prepare() {
	G2CONF="${G2CONF}
		VALAC=$(type -p valac-0.12)"
		#$(use_enable vala)

	if [[ ${PV} = 9999 ]]; then
		# XXX: gtk-doc.make should be in top_srcdir -- file a bug for this
		# Let's only do this in the live version to avoid gtkdocize in releases
		sed -e 's:^include gtk-doc.make:include $(top_srcdir)/gtk-doc.make:' \
			-i docs/Makefile.am || die "Fixing gtk-doc.make failed"
	fi

	# Fix vala automagic support, upstream bug #634171
	# FIXME: patch doesn't actually work, forcing vala support above
	#epatch "${FILESDIR}/${PN}-automagic-vala.patch"

	gnome2_src_prepare
}
