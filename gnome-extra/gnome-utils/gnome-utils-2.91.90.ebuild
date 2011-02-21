# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-utils/gnome-utils-2.32.0-r1.ebuild,v 1.1 2010/12/04 18:08:10 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Utilities for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="bonobo doc ipv6 test"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
fi

# libcanberra 0.26-r2 is needed for gtk+:3 fixes
RDEPEND=">=dev-libs/glib-2.26.0:2
	>=x11-libs/gtk+-2.91.1:3
	>=gnome-base/gconf-2
	>=gnome-base/gnome-panel-2.13.4
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	>=gnome-base/libgtop-2.12
	>=media-libs/libcanberra-0.26-r2[gtk3]
	x11-libs/libXext
	x11-libs/libX11
	bonobo? ( || ( gnome-base/gnome-panel[bonobo] <gnome-base/gnome-panel-2.32 ) )"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.10 )"

pkg_setup() {
	if ! use debug; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF}
		$(use_enable ipv6)
		$(use_enable bonobo gdict-applet)
		--enable-zlib
		--disable-maintainer-flags
		--disable-static
		--disable-schemas-install
		--disable-schemas-compile
		--disable-scrollkeeper"
	DOCS="AUTHORS ChangeLog NEWS README THANKS"
}

src_prepare() {
	gnome2_src_prepare

	# Remove idiotic -D.*DISABLE_DEPRECATED cflags
	# This method is kinda prone to breakage. Recheck carefully with next bump.
	# bug 339074
	find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"
	# Do Makefile.in after Makefile.am to avoid automake maintainer-mode
	find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"

	if ! use test ; then
		sed -e 's/ tests//' -i logview/Makefile.{am,in} || die "sed 2 failed"
	fi
}
