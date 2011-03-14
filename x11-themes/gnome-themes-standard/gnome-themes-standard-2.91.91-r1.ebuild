# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-themes/gnome-themes-2.32.0.ebuild,v 1.1 2010/10/12 18:05:05 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="Adwaita theme for GNOME Shell"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# Double-check gtk/gtk-engines/metacity/mutter dependencies
RDEPEND=">=x11-libs/gtk+-2.91.6:3
	>=x11-themes/gtk-engines-2.15.3"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.40
	sys-devel/gettext"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"
# FIXME: --enable-placeholders fails
G2CONF="--disable-static --disable-placeholders"
DOCS="ChangeLog NEWS"

src_prepare() {
	gnome2_src_prepare
	# Install cursors in the right place
	sed -e 's:^\(cursordir.*\)icons\(.*\):\1cursors/xorg-x11\2:' \
		-i themes/Adwaita/cursors/Makefile.am \
		-i themes/Adwaita/cursors/Makefile.in || die
	# Take from upstream drop next release
	epatch "${FILESDIR}/${P}-fix-typo.patch"
}

src_install() {
	gnome2_src_install

	# Make it the default cursor theme
	cd "${ED}/usr/share/cursors/xorg-x11" || die
	ln -sfn Adwaita default || die
}
