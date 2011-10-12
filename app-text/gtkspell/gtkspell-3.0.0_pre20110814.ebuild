# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gtkspell/gtkspell-2.0.16.ebuild,v 1.9 2011/09/18 09:41:22 ssuominen Exp $

EAPI="4"
inherit autotools eutils

DESCRIPTION="Spell checking widget for GTK"
HOMEPAGE="http://gtkspell.sourceforge.net/"
# gtkspell doesn't use sourceforge mirroring system it seems.
SRC_URI="http://${PN}.sourceforge.net/download/${PN}-2.0.16.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="" #doc

RDEPEND=">=app-text/enchant-1.1.6
	x11-libs/gtk+:3
	>=x11-libs/pango-1.8.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0

	>=dev-util/gtk-doc-1.17
	app-text/docbook-xml-dtd:4.2"
#	doc? ( >=dev-util/gtk-doc-1.17 app-text/docbook-xml-dtd:4.2 )

DOCS=( AUTHORS ChangeLog README ) # NEWS file is empty
S="${WORKDIR}/${PN}-2.0.16"

src_prepare() {
	# Apply upstream hg patches for gtk3 support
	rm -f docs/gtkspell-{docs.sgml,sections.txt} gtkspell-2.0.pc.in	|| die "rm failed"
	cp "${FILESDIR}/${PV}/gtkspell3-"{docs.sgml,sections.txt} docs || die "cp failed"
	cp "${FILESDIR}/${PV}/gtkspell-3.0.pc.in" . || die "cp failed"
	epatch "${FILESDIR}/${PV}"/*.patch

	# Fix intltoolize broken file, see upstream #577133
	sed -i -e "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" po/Makefile.in.in || die

	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-gtk-doc
#		$(use_enable doc gtk-doc)
	# Must force-rebuild gtk-doc after the gtk3 patch, since the pre-built docs
	# are for the gtk2 version.
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
