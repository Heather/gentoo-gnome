# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmime/gmime-2.4.25.ebuild,v 1.1 2011/06/11 15:17:27 pacho Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 eutils mono libtool
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Utilities for creating and parsing messages using MIME"
HOMEPAGE="http://spruce.sourceforge.net/gmime/"

SLOT="2.6"
LICENSE="LGPL-2.1"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
fi
IUSE="doc mono static-libs"

RDEPEND=">=dev-libs/glib-2.18:2
	>=app-crypt/gpgme-1.1.6
	sys-libs/zlib
	mono? (
		dev-lang/mono
		>=dev-dotnet/glib-sharp-2.4.0:2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		>=dev-util/gtk-doc-1.8
		app-text/docbook-sgml-utils )
	mono? ( dev-dotnet/gtk-sharp-gapi:2 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS PORTING README TODO"
	G2CONF="${G2CONF}
		$(use_enable mono)
		$(use_enable static-libs static)
		--enable-cryptography"
}

src_prepare() {
	gnome2_src_prepare

	if use doc ; then
		# db2html should be docbook2html
		sed -i -e 's:db2html:docbook2html:' \
			configure.ac configure || die "sed failed (1)"
		sed -i -e 's:db2html:docbook2html -o gmime-tut:g' \
			docs/tutorial/Makefile.* || die "sed failed (2)"
		# Fix doc targets (bug #97154)
		sed -i -e 's!\<\(tmpl-build.stamp\): !\1 $(srcdir)/tmpl/*.sgml: !' \
			gtk-doc.make docs/reference/Makefile.in || die "sed failed (3)"
	fi

	# Use correct libdir for mono assembly
	sed -i -e 's:^libdir.*:libdir=@libdir@:' \
		   -e 's:^prefix=:exec_prefix=:' \
		   -e 's:prefix)/lib:libdir):' \
		mono/gmime-sharp.pc.in mono/Makefile.{am,in} || die "sed failed (4)"

	elibtoolize
}

src_compile() {
	MONO_PATH="${S}" emake
	if use doc; then
		emake -C docs/tutorial html
	fi
}

src_install() {
	GACUTIL_FLAGS="/root '${ED}/usr/$(get_libdir)' /gacdir '${EPREFIX}/usr/$(get_libdir)' /package ${PN}" \
		gnome2_src_install

	if use doc ; then
		# we don't use docinto/dodoc, because we don't want html doc gzipped
		insinto /usr/share/doc/${PF}/tutorial
		doins docs/tutorial/html/*
	fi

	dodoc $DOCS

	# rename these two, so they don't conflict with app-arch/sharutils
	# (bug #70392)	Ticho, 2004-11-10
	mv "${ED}/usr/bin/uuencode" "${ED}/usr/bin/gmime-uuencode-${SLOT}"
	mv "${ED}/usr/bin/uudecode" "${ED}/usr/bin/gmime-uudecode-${SLOT}"
}
