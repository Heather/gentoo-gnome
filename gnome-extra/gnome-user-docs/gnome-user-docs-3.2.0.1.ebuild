# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GNOME end user documentation"
HOMEPAGE="http://www.gnome.org/"

LICENSE="CC-Attribution-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

# Newer gnome-doc-utils is needed for RNGs
# libxml2 needed for xmllint
# scrollkeeper is referenced in gnome-user-docs.spec, but is not used
RDEPEND=""
DEPEND=">=app-text/gnome-doc-utils-0.20.5
	dev-libs/libxml2
	dev-util/itstool
	sys-devel/gettext"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_pretend() {
	if [[ -z ${LINGUAS} ]]; then
		ewarn "You are building ${PN} with LINGUAS unset, so help files"
		ewarn "in all languages supported by the package will be built."
		ewarn
		ewarn "To decrease build time, it is recommended that you set LINGUAS"
		ewarn "in /etc/make.conf to the set of language codes that are needed"
		ewarn "for your system. For example,"
		ewarn "LINGUAS=\"en es\""
		ewarn "ensures that only English and Spanish translations are built."
	fi
}
