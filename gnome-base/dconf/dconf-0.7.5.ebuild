# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2 bash-completion
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="http://live.gnome.org/dconf"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc +X"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~sparc ~x86"
fi

COMMON_DEPEND=">=dev-libs/glib-2.27.2:2
	sys-apps/dbus
	X? (
		>=dev-libs/libxml2-2.7.7:2
		x11-libs/gtk+:3 )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/vala-0.11.7:0.12
	doc? ( >=dev-util/gtk-doc-1.15 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-schemas-compile
		VALAC=$(type -p valac-0.12)
		$(use_enable X editor)"
		#$(use_enable vala)
}

src_prepare() {
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

src_install() {
	gnome2_src_install

	# GSettings backend may be one of: memory, gconf, dconf
	# Only dconf is really considered functional by upstream
	# must have it enabled over gconf if both are installed
	echo 'CONFIG_PROTECT_MASK="/etc/dconf"' >> 51dconf
	echo 'GSETTINGS_BACKEND="dconf"' >> 51dconf
	doenvd 51dconf || die "doenvd failed"

	# Remove bash-completion file installed by build system
	rm -rv "${ED}/etc/bash_completion.d/" || die

	use bash-completion && \
		dobashcompletion "${S}/bin/dconf-bash-completion.sh" ${PN}
}

pkg_postinst() {
	gnome2_pkg_postinst
	use bashcompletion && bash-completion_pkg_postinst
}
