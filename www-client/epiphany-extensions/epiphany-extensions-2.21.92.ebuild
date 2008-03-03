# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany-extensions/epiphany-extensions-2.20.3.ebuild,v 1.3 2008/02/17 23:17:49 eva Exp $

inherit autotools eutils gnome2 python versionator

MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Extensions for the Epiphany web browser"
HOMEPAGE="http://www.gnome.org/projects/epiphany/extensions.html"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="dbus example pcre python useless"

RDEPEND="app-text/opensp
		 >=dev-libs/glib-2.15.5
		 >=gnome-base/gconf-2.0
		 >=dev-libs/libxml2-2.6
		 >=x11-libs/gtk+-2.11.6
		 >=gnome-base/libglade-2
		 dbus? ( >=dev-libs/dbus-glib-0.34 )
		 pcre? ( >=dev-libs/libpcre-3.9-r2 )
		 python? ( >=dev-python/pygtk-2.11 )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.20
		>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	local extensions=

	extensions="actions auto-reload auto-scroller certificates error-viewer \
				extensions-manager-ui gestures java-console page-info push-scroller \
				select-stylesheet sidebar smart-bookmarks tab-groups tab-states"

	use dbus && extensions="${extensions} rss"

	use pcre && extensions="${extensions} adblock"
	use pcre && use useless && extensions="${extensions} greasemonkey"

	use python && extensions="${extensions} python-console favicon cc-license-viewer"
	use python && use example && extensions="${extensions} sample-python"
	use python && use useless && extensions="${extensions} epilicious"

	use example && extensions="${extensions} sample sample-mozilla"
	use useless && extensions="${extensions} livehttpheaders permissions"


	G2CONF="${G2CONF} --with-extensions=$(echo "${extensions}" | sed -e 's/[[:space:]]\+/,/g')"
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use python; then
		python_version
		python_mod_optimize	/usr/$(get_libdir)/epiphany/${MY_MAJORV}/extensions
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if use python; then
		python_version
		python_mod_cleanup /usr/$(get_libdir)/epiphany/${MY_MAJORV}/extensions
	fi
}
