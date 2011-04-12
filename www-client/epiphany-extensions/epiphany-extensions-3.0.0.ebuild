# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany-extensions/epiphany-extensions-2.32.0.ebuild,v 1.7 2011/03/22 13:49:29 xarthisius Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit gnome2 python

DESCRIPTION="Extensions for the Epiphany web browser"
HOMEPAGE="http://www.gnome.org/projects/epiphany/extensions.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="dbus examples pcre"

RDEPEND=">=www-client/epiphany-3.0.0
	app-text/opensp
	>=dev-libs/glib-2.26.0:2
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/gtk+-2.90.4:3
	net-libs/webkit-gtk:3

	dbus? ( >=dev-libs/dbus-glib-0.34 )
	pcre? ( >=dev-libs/libpcre-3.9-r2 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.20
	>=app-text/gnome-doc-utils-0.3.2"
# eautoreconf dependencies:
#	  gnome-base/gnome-common

# FIXME: Open security issues:
# XXX: Check if this is still valid
# FIXME: - adblock        ( https://bugzilla.gnome.org/show_bug.cgi?id=595255 )

pkg_setup() {
	local extensions=""
	# XXX: Only enable default/useful extensions?
	extensions="actions auto-reload certificates \
			   error-viewer extensions-manager-ui gestures html5tube \
			   java-console livehttpheaders page-info \
			   push-scroller select-stylesheet \
			   smart-bookmarks soup-fly tab-states"
	use dbus && extensions="${extensions} rss"
	use pcre && extensions="${extensions} greasemonkey"
	use examples && extensions="${extensions} sample"

	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-maintainer-mode
		--with-extensions=$(echo "${extensions}" | sed -e 's/[[:space:]]\+/,/g')"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare
	python_convert_shebangs -r 2 .
}
