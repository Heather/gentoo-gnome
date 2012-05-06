# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live # to avoid duplicating hacks from gnome2-live_src_prepare
fi

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11."
HOMEPAGE="http://p11-glue.freedesktop.org/p11-kit.html"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/p11-glue/p11-kit"
else
	SRC_URI="http://p11-glue.freedesktop.org/releases/${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~hppa ~x86"
fi
IUSE="debug doc"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.15
	)
"

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	econf \
		--disable-maintainer-mode \
		--with-system-config="${EPREFIX}/etc/pkcs11" \
		$(use_enable debug) \
		$(use_enable doc gtk-doc)
}

src_install() {
	default
}
