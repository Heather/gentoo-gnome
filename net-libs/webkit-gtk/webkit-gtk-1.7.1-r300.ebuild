# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-1.6.1-r300.ebuild,v 1.1 2011/09/30 13:52:33 nirbheek Exp $

EAPI="4"

# Don't define PYTHON_DEPEND: python only needed at build time
inherit autotools eutils flag-o-matic eutils python virtualx

MY_P="webkit-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
# Upstream is still shipping silly gzip files
SRC_URI="http://www.webkitgtk.org/${MY_P}.tar.gz"
#SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd
~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
# geoclue
IUSE="aqua coverage debug doc +gstreamer +introspection +jit spell webgl"
# bug 372493
REQUIRED_USE="introspection? ( gstreamer )"

# use sqlite, svg by default
# dependency on >=x11-libs/gtk+-2.13:2 for gail
# Aqua support in gtk3 is untested
# gtk2 is needed for plugin process support
RDEPEND="
	dev-libs/libxml2:2
	dev-libs/libxslt
	virtual/jpeg
	>=media-libs/libpng-1.4:0
	>=x11-libs/cairo-1.10
	>=dev-libs/glib-2.27.90:2
	>=x11-libs/gtk+-3.0:3[aqua=,introspection?]
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.33.6:2.4[introspection?]
	dev-db/sqlite:3
	>=x11-libs/pango-1.12
	x11-libs/libXrender

	gstreamer? (
		media-libs/gstreamer:0.10
		>=media-libs/gst-plugins-base-0.10.30:0.10 )

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )

	spell? ( >=app-text/enchant-0.22 )

	webgl? ( virtual/opengl )
"
DEPEND="${RDEPEND}
	=dev-lang/python-2*
	>=sys-devel/flex-2.5.33
	sys-devel/gettext
	virtual/yacc
	dev-util/gperf
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.10 )
	test? ( x11-themes/hicolor-icon-theme )
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# Needed for CodeGeneratorInspector.py
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	DOCS="ChangeLog NEWS" # other ChangeLog files handled by src_install

	# FIXME: Fix unaligned accesses on ARM, IA64 and SPARC
	# https://bugs.webkit.org/show_bug.cgi?id=19775
	use sparc && epatch "${FILESDIR}"/${PN}-1.2.3-fix-pool-sparc.patch

	# intermediate MacPorts hack while upstream bug is not fixed properly
	# https://bugs.webkit.org/show_bug.cgi?id=28727
	use aqua && epatch "${FILESDIR}"/${PN}-1.2.5-darwin-quartz.patch

	# Fix build on Darwin8 (10.4 Tiger)
	# XXX: Fails to apply
	#epatch "${FILESDIR}"/${PN}-1.2.5-darwin8.patch

	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/configure.ac

	# Don't build tests if not needed, part of bug #343249
	# XXX: Fails to apply
	#epatch "${FILESDIR}/${PN}-1.2.5-tests-build.patch"

	# Required for webgl; https://bugs.webkit.org/show_bug.cgi?id=69085
	mkdir -p DerivedSources/ANGLE

	# Install docs on "make install" when USE=doc
	epatch "${FILESDIR}/${PN}-1.7.1-install-docs.patch"

	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=Source/autotools eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this in LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co.
	use sparc && filter-flags "-mcpu=*" "-mvis" "-mtune=*"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	local myconf

	# XXX: Check Web Audio support
	# XXX: files for generating DerivedSources/WebKit2/* are missing, see
	#      https://bugs.webkit.org/show_bug.cgi?id=66527
	myconf="
		$(use_enable coverage)
		$(use_enable debug)
		$(use_enable debug debug-features)
		$(use_enable doc gtk-doc)
		$(use_enable spell spellcheck)
		$(use_enable introspection)
		$(use_enable gstreamer video)
		$(use_enable jit)
		$(use_enable webgl)
		--enable-web-sockets
		--with-gtk=3.0
		--disable-webkit2
		$(use aqua && echo "--with-font-backend=pango --with-target=quartz")"
		# Aqua support in gtk3 is untested

	econf ${myconf}
}

src_compile() {
	# Fix sandbox error with USE="introspection"
	# https://bugs.webkit.org/show_bug.cgi?id=35471
	emake XDG_DATA_HOME="${T}/.local"
}

src_test() {
	unset DISPLAY
	# Tests need virtualx, bug #294691, bug #310695
	# Set XDG_DATA_HOME for introspection tools, bug #323669
	# Parallel tests sometimes fail
	Xemake -j1 check XDG_DATA_HOME="${T}/.local"
}

src_install() {
	default

	newdoc Source/WebKit/gtk/ChangeLog ChangeLog.gtk
	newdoc Source/WebKit/gtk/po/ChangeLog ChangeLog.gtk-po
	newdoc Source/JavaScriptCore/ChangeLog ChangeLog.JavaScriptCore
	newdoc Source/WebCore/ChangeLog ChangeLog.WebCore

	# Remove .la files
	find "${D}" -name '*.la' -exec rm -f '{}' +
}
