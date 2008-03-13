# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrdao/cdrdao-1.2.2.ebuild,v 1.9 2007/11/14 19:27:22 drac Exp $

inherit flag-o-matic eutils

DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
HOMEPAGE="http://cdrdao.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdrdao/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gnome debug encode pccts"
RESTRICT="strip"

RDEPEND="encode? ( >=media-sound/lame-3.90 )
	gnome? ( >=dev-cpp/gtkmm-2.4
		>=dev-cpp/libgnomemm-2.6
		>=dev-cpp/libgnomecanvasmm-2.6
		>=dev-cpp/gconfmm-2.6
		>=dev-cpp/libgnomeuimm-2.6
		media-libs/libao )"
DEPEND="pccts? ( >=dev-util/pccts-1.33.24-r1 )
	virtual/cdrtools
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fixes bug #212530
	epatch "${FILESDIR}/${PN}-1.2.2-use-new-sigc++-API.patch"

	# FreeBSD needs this patch
	# I think the correct define should be linux, but this will maintain
	# the status quo for the time being.
	# Upstream bug #1596097
	epatch "${FILESDIR}/${P}"-nonlinux.patch

	# Display better SCSI messages (advise from Bug 43003)
	cd scsilib/include
	sed -i -e 's:HAVE_SCANSTACK:NO_FRIGGING_SCANSTACK:g' xmconfig.h
	sed -i -e 's:HAVE_SCANSTACK:NO_FRIGGING_SCANSTACK:g' mconfig.h
}

src_compile() {
	# A few CFLAGS do not work see bug #99998
	strip-flags
	append-flags "-fno-inline"

	econf \
		$(use_enable debug) \
		$(use_with gnome xdao) \
		$(use_with encode lame) \
		$(use_with pccts pcctsbin /usr/bin) \
		$(use_with pccts pcctsinc /usr/include/pccts) \
		--disable-dependency-tracking || die "configure failed"

	make || die "could not compile"
}

src_install() {
	einstall || die "could not install"

	cd "${S}"

	dodoc AUTHORS CREDITS ChangeLog NEWS README*
}
