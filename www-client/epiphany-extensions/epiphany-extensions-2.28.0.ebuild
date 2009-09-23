# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit autotools eutils gnome2 versionator

EAPI=2
MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Extensions for the Epiphany web browser"
HOMEPAGE="http://www.gnome.org/projects/epiphany/extensions.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="dbus examples pcre"

RDEPEND=">=www-client/epiphany-${MY_MAJORV}
	app-text/opensp
	>=dev-libs/glib-2.15.5
	>=gnome-base/gconf-2.0
	>=dev-libs/libxml2-2.6
	>=x11-libs/gtk+-2.12.0
	>=gnome-base/libglade-2
	>=net-libs/webkit-gtk-1.1

	dbus? ( >=dev-libs/dbus-glib-0.34 )
	pcre? ( >=dev-libs/libpcre-3.9-r2 )"
DEPEND="${RDEPEND}
	  gnome-base/gnome-common
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.20
	>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	local extensions=""

	extensions="actions auto-reload auto-scroller certificates \
			   error-viewer extensions-manager-ui \
			   java-console livehttpheaders page-info permissions \
			   push-scroller select-stylesheet \
			   smart-bookmarks soup-fly tab-groups tab-states"
	use dbus && extensions="${extensions} rss"

	use pcre && extensions="${extensions} greasemonkey"

	use examples && extensions="${extensions} sample"

	G2CONF="${G2CONF} --with-extensions=$(echo "${extensions}" | sed -e 's/[[:space:]]\+/,/g')"

}

src_prepare() {
	# Fix building with libtool-1  bug #257337
	rm m4/lt* m4/libtool.m4

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}
