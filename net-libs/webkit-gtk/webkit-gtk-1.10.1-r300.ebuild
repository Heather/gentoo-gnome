# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-1.8.1-r301.ebuild,v 1.5 2012/06/20 06:34:59 ssuominen Exp $

EAPI="4"

# Don't define PYTHON_DEPEND: python only needed at build time
inherit autotools flag-o-matic gnome2-utils pax-utils python virtualx

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
SRC_URI="http://www.webkitgtk.org/releases/${MY_P}.tar.xz"
#SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
# geoclue
IUSE="aqua coverage debug doc +geoloc +gstreamer +introspection +jit spell +webgl"
# bugs 372493, 416331
REQUIRED_USE="introspection? ( geoloc gstreamer )"

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
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.4:3[aqua=,introspection?]
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.39.2:2.4[introspection?]
	dev-db/sqlite:3
	>=x11-libs/pango-1.21
	x11-libs/libXrender
	>=x11-libs/gtk+-2.13:2

	geoloc? ( app-misc/geoclue )

	gstreamer? (
		media-libs/gstreamer:0.10
		>=media-libs/gst-plugins-base-0.10.30:0.10 )

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )

	spell? ( >=app-text/enchant-0.22 )

	webgl? (
		virtual/opengl
		x11-libs/libXcomposite )
"
# paxctl needed for bug #407085
DEPEND="${RDEPEND}
	dev-lang/perl
	=dev-lang/python-2*
	virtual/rubygems[ruby_targets_ruby18]
	sys-devel/bison
	>=sys-devel/flex-2.5.33
	sys-devel/gettext
	dev-util/gperf
	virtual/pkgconfig
	dev-util/gtk-doc-am
	app-accessibility/at-spi2-core

	>=sys-devel/make-3.82-r4

	doc? ( >=dev-util/gtk-doc-1.10 )
	introspection? ( jit? ( sys-apps/paxctl ) )
	test? (
		x11-themes/hicolor-icon-theme
		jit? ( sys-apps/paxctl ) )
"
# Need real bison, not yacc

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# Needed for CodeGeneratorInspector.py
	python_set_active_version 2
	python_pkg_setup
	if is-flagq "-g*" ; then
		einfo "You need ~23GB of free space to build this package with debugging CFLAGS."
	fi
}

src_prepare() {
	DOCS="ChangeLog NEWS" # other ChangeLog files handled by src_install

	# intermediate MacPorts hack while upstream bug is not fixed properly
	# https://bugs.webkit.org/show_bug.cgi?id=28727
	use aqua && epatch "${FILESDIR}"/${PN}-1.6.1-darwin-quartz.patch

	# Drop DEPRECATED flags
	LC_ALL=C sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' GNUmakefile.am || die

	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/configure.ac || die

	# Build-time segfaults under PaX with USE="introspection jit", bug #404215
	if use introspection && use jit; then
		epatch "${FILESDIR}/${PN}-1.6.3-paxctl-introspection.patch"
		cp "${FILESDIR}/gir-paxctl-lt-wrapper" "${S}/" || die
	fi

	# We need to reset some variables to prevent permissions problems and failures
	# like https://bugs.webkit.org/show_bug.cgi?id=35471 and bug #323669
	gnome2_environment_reset

	# XXX: failing tests
	# https://bugs.webkit.org/show_bug.cgi?id=50744
	# testkeyevents is interactive
	# mimehandling test sometimes fails under Xvfb (works fine manually)
	# datasource test needs a network connection and intermittently fails with
	#  icedtea-web
	sed -e '/Programs\/unittests\/testwebinspector/ d' \
		-e '/Programs\/unittests\/testkeyevents/ d' \
		-e '/Programs\/unittests\/testmimehandling/ d' \
		-e '/Programs\/unittests\/testwebdatasource/ d' \
		-i Source/WebKit/gtk/GNUmakefile.am || die
	if ! use gstreamer; then
		# webkit2's TestWebKitWebView requires <video> support
		sed -e '/Programs\/WebKit2APITests\/TestWebKitWebView/ d' \
			-i Source/WebKit2/UIProcess/API/gtk/tests/GNUmakefile.am || die
	fi
	# garbage collection test fails intermittently if icedtea-web is installed
	epatch "${FILESDIR}/${PN}-1.7.90-test_garbage_collection.patch"

	# occasional test failure due to additional Xvfb process spawned
	# TODO epatch "${FILESDIR}/${PN}-1.8.1-tests-xvfb.patch"

	# bug #417523, https://bugs.webkit.org/show_bug.cgi?id=96602
	epatch "${FILESDIR}/${PN}-1.9.91-libdl.patch"

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=Source/autotools eautoreconf

	# Ugly hack of a workaround for bizarre paludis behavior, bug #406117
	# http://paludis.exherbo.org/trac/ticket/1230
	sed -e '/  --\(en\|dis\)able-dependency-tracking/ d' -i configure || die
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
		--with-gtk=3.0
		--enable-dependency-tracking
		--with-gstreamer=0.10
		RUBY=$(type -P ruby18)
		$(use aqua && echo "--with-font-backend=pango --with-target=quartz")"
		# Aqua support in gtk3 is untested

	econf ${myconf}
}

src_compile() {
	# Avoid parallel make failure with -j9
	emake DerivedSources/WebCore/JSNode.h
	default
}

src_test() {
	# Tests expect an out-of-source build in WebKitBuild
	ln -s . WebKitBuild || die "ln failed"

	# Prevents test failures on PaX systems
	use jit && pax-mark m $(list-paxables Programs/*[Tt]ests/*) \
		Programs/unittests/.libs/test*
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
	use jit && pax-mark m "${ED}usr/bin/jsc-3"
}
