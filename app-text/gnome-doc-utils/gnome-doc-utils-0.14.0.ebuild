# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnome-doc-utils/gnome-doc-utils-0.12.2-r1.ebuild,v 1.9 2008/07/28 17:05:18 drac Exp $

inherit autotools eutils python gnome2

DESCRIPTION="A collection of documentation utilities for the Gnome project"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.12
	 >=dev-libs/libxslt-1.1.8
	 >=dev-lang/python-2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	~app-text/docbook-xml-dtd-4.4"

DOCS="AUTHORS ChangeLog NEWS README"

src_unpack() {
	gnome2_src_unpack

	# Make xml2po FHS compliant, bug #190798
	epatch "${FILESDIR}/${PN}-0.12.2-fhs.patch"

	# Beware of first install, bug #224609
	AT_M4DIR="tools" eautomake
}

pkg_setup() {
	G2CONF="--disable-scrollkeeper"

	if ! built_with_use dev-libs/libxml2 python; then
		eerror "Please re-emerge dev-libs/libxml2 with the python use flag set"
		die "dev-libs/libxml2 needs python use flag"
	fi
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/xml2po
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup /usr/lib/python*/site-packages/xml2po
	gnome2_pkg_postrm
}
