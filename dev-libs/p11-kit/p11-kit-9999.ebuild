# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

if [[ ${PV} = 9999 ]]; then
	GCONF_DEBUG="no"
	inherit gnome2-live # to avoid duplicating hacks from gnome2-live_src_prepare
fi

DESCRIPTION="Library and proxy module for loading and sharing PKCS#11 modules"
HOMEPAGE="http://p11-glue.freedesktop.org/p11-kit.html"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/p11-glue/p11-kit"
else
	SRC_URI="http://p11-glue.freedesktop.org/releases/${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.15
	)
"

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	econf \
		--disable-coverage \
		--disable-maintainer-mode \
		--with-system-config="${EPREFIX}/etc/pkcs11" \
		$(use_enable doc gtk-doc)
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
