# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/devhelp/devhelp-0.16.1.ebuild,v 1.7 2007/11/27 11:11:23 eva Exp $

inherit toolchain-funcs gnome2

DESCRIPTION="An API documentation browser for GNOME 2"
HOMEPAGE="http://developer.imendio.com/wiki/Devhelp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="xulrunner zlib"

RDEPEND=">=gnome-base/gconf-2.6
		 >=x11-libs/gtk+-2.8
		 >=dev-libs/glib-2.8
		 >=gnome-base/libglade-2.4
		 >=x11-libs/libwnck-2.10
		 xulrunner? ( net-libs/xulrunner )
		 !xulrunner? ( >=www-client/mozilla-firefox-1.0.2-r1 )
		 zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
		  sys-devel/gettext
		>=dev-util/intltool-0.35.5
		>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="$(use_with zlib)"

	if use xulrunner ; then
		G2CONF="${G2CONF} --with-gecko=xulrunner"
	else
		G2CONF="${G2CONF} --with-gecko=firefox"
	fi

	# ICC is crazy, silence warnings (bug #154010)
	if [[ $(tc-getCC) == "icc" ]] ; then
		G2CONF="${G2CONF} --with-compile-warnings=no"
	fi
}
