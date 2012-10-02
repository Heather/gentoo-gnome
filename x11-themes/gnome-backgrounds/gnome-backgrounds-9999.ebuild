# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2
[[ ${PV} = 9999 ]] && inherit gnome2-live

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
fi
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	>=dev-util/intltool-0.40.0"

DOCS="AUTHORS ChangeLog NEWS README"
