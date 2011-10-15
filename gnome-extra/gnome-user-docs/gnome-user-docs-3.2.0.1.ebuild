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
# Explicit linguas_ handling since building all translations takes forever
# XXX: keep LANGS list in sync with package! ("C" is always installed)
LANGS="ca de es fi fr gl hi hu nl ru sl sv vi"
for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

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

pkg_setup() {
	# Treat unset LINGUAS as empty (building all translations takes forever).
	export LINGUAS="${LINGUAS-}"
}
