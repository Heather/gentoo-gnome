# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-base/gnome-python-base-2.26.1.ebuild,v 1.4 2009/10/16 21:45:52 maekke Exp $

GCONF_DEBUG="no"

inherit versionator eutils gnome2

# This ebuild does nothing -- we just want to get the pkgconfig file installed

MY_PN="gnome-python"
DESCRIPTION="Provides the base files for the gnome-python bindings"
HOMEPAGE="http://pygtk.org/"
PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP}/${MY_PN}-${PV}.tar.bz2"

IUSE=""
LICENSE="LGPL-2.1"
SLOT="2"
RESTRICT="${RESTRICT} test"

# From the gnome-python eclass
RDEPEND=">=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.6
	>=dev-python/pygtk-2.14.0
	>=dev-python/pygobject-2.17
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	G2CONF="${G2CONF} --disable-allbindings"
}
