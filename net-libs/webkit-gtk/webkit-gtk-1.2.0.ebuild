# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools flag-o-matic eutils virtualx

MY_P="webkit-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
SRC_URI="http://www.webkitgtk.org/${MY_P}.tar.gz"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
# geoclue
IUSE="coverage debug doc +gstreamer introspection pango +websockets" # aqua

# use sqlite, svg by default
# dependency on >=x11-libs/gtk+-2.13 for gail
# XXX: Quartz patch does not apply
# >=x11-libs/gtk+-2.13[aqua=]
RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/jpeg:0
	media-libs/libpng
	x11-libs/cairo
	>=x11-libs/gtk+-2.13
	>=dev-libs/glib-2.21.3
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.29.90
	>=dev-db/sqlite-3
	>=app-text/enchant-0.22
	>=x11-libs/pango-1.12

	gstreamer? (
		media-libs/gstreamer:0.10
		>=media-libs/gst-plugins-base-0.10.25:0.10 )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.2
		!!dev-libs/gir-repository[webkit]
		dev-libs/gir-repository[libsoup] )
"

DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.33
	sys-devel/gettext
	dev-util/gperf
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.10 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Build failure with icu-4.4, bug 308699
	epatch "${FILESDIR}"/webkit-icu-4.4.patch

	# FIXME: Fix unaligned accesses on ARM, IA64 and SPARC
	use sparc && epatch "${FILESDIR}"/${PN}-1.1.15.2-unaligned.patch

	# Darwin/Aqua build is broken, needs autoreconf
	# XXX: BROKEN. Patch does not apply anymore.
	#epatch "${FILESDIR}"/${PN}-1.1.15.4-darwin-quartz.patch

	# Make it libtool-1 compatible
	rm -v autotools/lt* autotools/libtool.m4 \
		|| die "removing libtool macros failed"
	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/configure.ac || die "sed failed"
	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=autotools eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this in LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu
	use sparc && filter-flags "-mcpu=*" "-mtune=*"

	local myconf

	myconf="
		$(use_enable coverage)
		$(use_enable debug)
		$(use_enable gstreamer video)
		$(use_enable introspection)
		$(use_enable websockets web_sockets)"
		# quartz patch above does not apply anymore
		#$(use aqua && echo "--with-target=quartz")"

	econf ${myconf}
}

src_test() {
	unset DISPLAY
	# Tests will fail without it, bug 294691, bug 310695
	Xemake check || die "Test phase failed"
}

src_compile() {
	# Fix sandbox error with USE="introspection"
	addpredict "$(unset HOME; echo ~)/.local"
	emake || die "Compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc WebKit/gtk/{NEWS,ChangeLog} || die "dodoc failed"
}
