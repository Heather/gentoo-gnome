# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gsettings-desktop-schemas/gsettings-desktop-schemas-3.2.0-r1.ebuild,v 1.5 2012/01/18 20:35:56 maekke Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND=">=dev-libs/glib-2.31:2
	introspection? ( >=dev-libs/gobject-introspection-1.31.0 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)"
	DOCS="AUTHORS HACKING NEWS README"
}
