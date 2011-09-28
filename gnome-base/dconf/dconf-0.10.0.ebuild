# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit autotools eutils gnome2 bash-completion
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="http://live.gnome.org/dconf"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc vala +X"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~sparc ~x86"
fi

COMMON_DEPEND=">=dev-libs/glib-2.29.90:2
	sys-apps/dbus
	X? (
		>=dev-libs/libxml2-2.7.7:2
		x11-libs/gtk+:3 )"
# vala:0.14 due to an automagic version-check #ifdef (commit a15d9621)
DEPEND="${COMMON_DEPEND}
	doc? ( >=dev-util/gtk-doc-1.15 )
	vala? ( dev-lang/vala:0.14 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-schemas-compile
		$(use_enable vala)
		$(use_enable X editor)
		VALAC=$(type -p valac-0.14)"
}

src_prepare() {
	if [[ ${PV} = 9999 ]]; then
		# XXX: gtk-doc.make should be in top_srcdir -- file a bug for this
		# Let's only do this in the live version to avoid gtkdocize in releases
		sed -e 's:^include gtk-doc.make:include $(top_srcdir)/gtk-doc.make:' \
			-i docs/Makefile.am || die "Fixing gtk-doc.make failed"
	fi

	# Fix vala automagic support, upstream bug #634171
	epatch "${FILESDIR}/${PN}-automagic-vala.patch"

	if [[ ${PV} != 9999 ]]; then
		mkdir -p m4 || die
		AT_M4DIR="." eautoreconf
		eautoreconf
	fi
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	# GSettings backend may be one of: memory, gconf, dconf
	# Only dconf is really considered functional by upstream
	# must have it enabled over gconf if both are installed
	echo 'CONFIG_PROTECT_MASK="/etc/dconf"' >> 51dconf
	echo 'GSETTINGS_BACKEND="dconf"' >> 51dconf
	doenvd 51dconf

	# Remove bash-completion file installed by build system
	rm -rv "${ED}/etc/bash_completion.d/" || die
	use bash-completion && \
		dobashcompletion "${S}/bin/dconf-bash-completion.sh" ${PN}
}

pkg_postinst() {
	gnome2_pkg_postinst
	use bash-completion && bash-completion_pkg_postinst
}
