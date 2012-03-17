# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-1.6.1-r300.ebuild,v 1.1 2011/09/30 13:52:33 nirbheek Exp $

EAPI="4"

# Don't define PYTHON_DEPEND: python only needed at build time
inherit autotools eutils flag-o-matic gnome2-utils pax-utils python virtualx

MY_P="webkit-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
SRC_URI="http://www.webkitgtk.org/${MY_P}.tar.xz"
#SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
# geoclue
IUSE="aqua coverage debug doc +geoloc +gstreamer +introspection +jit spell +webgl"
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
	>=dev-libs/glib-2.31.2:2
	>=x11-libs/gtk+-3.0:3[aqua=,introspection?]
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.37.2.1:2.4[introspection?]
	dev-db/sqlite:3
	>=x11-libs/pango-1.21
	x11-libs/libXrender

	geoloc? ( app-misc/geoclue )

	gstreamer? (
		media-libs/gstreamer:0.10
		>=media-libs/gst-plugins-base-0.10.30:0.10 )

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )

	spell? ( >=app-text/enchant-0.22 )

	webgl? ( virtual/opengl )
"
# paxctl needed for bug #407085
DEPEND="${RDEPEND}
	dev-lang/perl
	=dev-lang/python-2*
	sys-devel/bison
	>=sys-devel/flex-2.5.33
	sys-devel/gettext
	dev-util/gperf
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	sys-apps/paxctl
	doc? ( >=dev-util/gtk-doc-1.10 )
	test? ( x11-themes/hicolor-icon-theme )
"
# Need real bison, not yacc

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
	# TODO: FAILS TO APPLY!
	#use sparc && epatch "${FILESDIR}"/${PN}-1.2.3-fix-pool-sparc.patch

	# intermediate MacPorts hack while upstream bug is not fixed properly
	# https://bugs.webkit.org/show_bug.cgi?id=28727
	use aqua && epatch "${FILESDIR}"/${PN}-1.6.1-darwin-quartz.patch

	# Bug #403049, https://bugs.webkit.org/show_bug.cgi?id=79605
	epatch "${FILESDIR}/${PN}-1.7.5-linguas.patch"

	# Drop DEPRECATED flags
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' GNUmakefile.am || die

	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/configure.ac || die

	# Build-time segfaults under PaX with USE="introspection jit", bug #404215
	epatch "${FILESDIR}/${PN}-1.6.3-paxctl-introspection.patch"
	cp "${FILESDIR}/gir-paxctl-lt-wrapper" "${S}/" || die

	# We need to reset some variables to prevent permissions problems and failures
	# like https://bugs.webkit.org/show_bug.cgi?id=35471 and bug #323669
	gnome2_environment_reset

	# https://bugs.webkit.org/show_bug.cgi?id=79498
	epatch "${FILESDIR}/${PN}-1.7.90-parallel-make-hack.patch"

	# XXX: failing tests
	# https://bugs.webkit.org/show_bug.cgi?id=50744
	# testkeyevents is interactive
	# mimehandling test sometimes fails under Xvfb (works fine manually)
	sed -e '/Programs\/unittests\/testwebinspector/ d' \
		-e '/Programs\/unittests\/testkeyevents/ d' \
		-e '/Programs\/unittests\/testmimehandling/ d' \
		-i Source/WebKit/gtk/GNUmakefile.am || die
	# garbage collection test fails intermittently if icedtea-web is installed
	epatch "${FILESDIR}/${PN}-1.7.90-test_garbage_collection.patch"

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=Source/autotools eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this in LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co.
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	local myconf

	# XXX: Check Web Audio support
	# XXX: dependency-tracking is required so parallel builds won't fail
	myconf="
		$(use_enable coverage)
		$(use_enable debug)
		$(use_enable debug debug-features)
		$(use_enable doc gtk-doc)
		$(use_enable geoloc geolocation)
		$(use_enable spell spellcheck)
		$(use_enable introspection)
		$(use_enable gstreamer video)
		$(use_enable jit)
		$(use_enable webgl)
		--enable-web-sockets
		--with-gtk=3.0
		--disable-webkit2
		--enable-dependency-tracking
		$(use aqua && echo "--with-font-backend=pango --with-target=quartz")"
		# Aqua support in gtk3 is untested

	econf ${myconf}
}

src_compile() {
	# Horrible failure of a hack to work around parallel make problems,
	# see https://bugs.webkit.org/show_bug.cgi?id=79498
	emake all-built-sources-local
	emake all-ltlibraries-local
	emake all-programs-local
	use introspection && emake WebKit-3.0.gir
	emake all-data-local
	default
}

src_test() {
	unset DISPLAY
	# Tests need virtualx, bug #294691, bug #310695
	# Parallel tests sometimes fail
	Xemake -j1 check
}

src_install() {
	default

	newdoc Source/WebKit/gtk/ChangeLog ChangeLog.gtk
	newdoc Source/WebKit/gtk/po/ChangeLog ChangeLog.gtk-po
	newdoc Source/JavaScriptCore/ChangeLog ChangeLog.JavaScriptCore
	newdoc Source/WebCore/ChangeLog ChangeLog.WebCore

	# Remove .la files
	find "${D}" -name '*.la' -exec rm -f '{}' +

	# Prevents crashes on PaX systems
	pax-mark m "${ED}usr/bin/jsc-3"
}
