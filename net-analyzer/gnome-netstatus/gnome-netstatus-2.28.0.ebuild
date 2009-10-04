# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gnome-netstatus/gnome-netstatus-2.26.0.ebuild,v 1.1 2009/05/17 22:28:54 eva Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Network interface information applet"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.16
	>=dev-libs/glib-2
	>=gnome-base/gnome-panel-2
	>=gnome-base/gconf-2"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	app-text/scrollkeeper
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

pkg_setup() {
	if ! use debug; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi
	G2CONF="${G2CONF}
		--disable-deprecations
		--disable-scrollkeeper"
}

src_prepapre() {
	gnome2_src_prepare

	# Fix interface listing on all (known) arches; bug #183969
	epatch "${FILESDIR}"/${PN}-2.12.1-fix-iflist.patch

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}
