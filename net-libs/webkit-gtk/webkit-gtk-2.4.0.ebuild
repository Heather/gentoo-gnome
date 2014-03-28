# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools check-reqs eutils flag-o-matic gnome2-utils pax-utils python-any-r1 toolchain-funcs versionator virtualx

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
SRC_URI="http://www.webkitgtk.org/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2+ BSD"
SLOT="3/29" # soname version
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="aqua coverage debug +egl +geoloc gles2 +gstreamer +introspection +jit libsecret +opengl spell +webgl"
# bugs 372493, 416331
REQUIRED_USE="
	geoloc? ( introspection )
	introspection? ( gstreamer )
	webgl? ( ^^ ( gles2 opengl ) )
	gles2? ( egl )
"

# use sqlite, svg by default
# Aqua support in gtk3 is untested
# gtk2 is needed for plugin process support
# gtk3-3.10 required for wayland
RDEPEND="
	dev-libs/libxml2:2
	dev-libs/libxslt
	media-libs/harfbuzz:=[icu(+)]
	media-libs/libwebp
	virtual/jpeg:0=
	>=media-libs/libpng-1.4:0=
	>=x11-libs/cairo-1.10:=[X]
	>=dev-libs/glib-2.36.0:2
	>=x11-libs/gtk+-3.6.0:3[aqua=,introspection?]
	>=dev-libs/icu-3.8.1-r1:=
	>=net-libs/libsoup-2.42.0:2.4[introspection?]
	dev-db/sqlite:3=
	>=x11-libs/pango-1.30.0.0
	x11-libs/libXrender
	>=x11-libs/gtk+-2.24.10:2

	egl? ( media-libs/mesa[egl] )
	geoloc? ( app-misc/geoclue:0 )
	gles2? ( media-libs/mesa[gles2] )
	gstreamer? (
		>=media-libs/gstreamer-1.0.3:1.0
		>=media-libs/gst-plugins-base-1.0.3:1.0 )
	introspection? ( >=dev-libs/gobject-introspection-1.32.0 )
	libsecret? ( app-crypt/libsecret )
	opengl? ( virtual/opengl )
	spell? ( >=app-text/enchant-0.22:= )
	webgl? (
		x11-libs/cairo[opengl]
		x11-libs/libXcomposite
		x11-libs/libXdamage )
"

# paxctl needed for bug #407085
# Need real bison, not yacc
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/perl
	|| (
		virtual/rubygems[ruby_targets_ruby20]
		virtual/rubygems[ruby_targets_ruby19]
		virtual/rubygems[ruby_targets_ruby18] )
	>=app-accessibility/at-spi2-core-2.5.3
	>=dev-util/gtk-doc-am-1.10
	dev-util/gperf
	sys-devel/bison
	>=sys-devel/flex-2.5.33
	|| ( >=sys-devel/gcc-4.7 >=sys-devel/clang-3.0 )
	sys-devel/gettext
	>=sys-devel/make-3.82-r4
	virtual/pkgconfig

	introspection? ( jit? ( sys-apps/paxctl ) )
	test? (
		dev-lang/python:2.7
		dev-python/pygobject:3[python_targets_python2_7]
		x11-themes/hicolor-icon-theme
		jit? ( sys-apps/paxctl ) )
"

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

pkg_pretend() {
	nvidia_check || die #463960

	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
		check-reqs_pkg_pretend
	fi

	if ! test-flag-CXX -std=c++11; then
		die "You need at least GCC 4.7.x or Clang >= 3.0 for C++11-specific compiler flags"
	fi
}

pkg_setup() {
	nvidia_check || die #463960

	# Check whether any of the debugging flags is enabled
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		if is-flagq "-ggdb" && [[ ${WEBKIT_GTK_GGDB} != "yes" ]]; then
			replace-flags -ggdb -g
			ewarn "Replacing \"-ggdb\" with \"-g\" in your CFLAGS."
			ewarn "Building ${PN} with \"-ggdb\" produces binaries which are too"
			ewarn "large for current binutils releases (bug #432784) and has very"
			ewarn "high temporary build space and memory requirements."
			ewarn "If you really want to build ${PN} with \"-ggdb\", add"
			ewarn "WEBKIT_GTK_GGDB=yes"
			ewarn "to your make.conf file."
		fi
		einfo "You need to have at least 18GB of temporary build space available"
		einfo "to build ${PN} with debugging CFLAGS. Note that it might still"
		einfo "not be enough, as the total space requirements depend on the flags"
		einfo "(-ggdb vs -g1) and enabled features."
		check-reqs_pkg_setup
	fi

	[[ ${MERGE_TYPE} = "binary" ]] || python-any-r1_pkg_setup
}

src_prepare() {
	DOCS="ChangeLog NEWS" # other ChangeLog files handled by src_install

	# intermediate MacPorts hack while upstream bug is not fixed properly
	# https://bugs.webkit.org/show_bug.cgi?id=28727
	use aqua && epatch "${FILESDIR}"/${PN}-1.6.1-darwin-quartz.patch

	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/Source/autotools/SetupCompilerFlags.m4 || die

	# Build-time segfaults under PaX with USE="introspection jit", bug #404215
	#if use introspection && use jit; then
	#	epatch "${FILESDIR}/${PN}-1.6.3-paxctl-introspection.patch"
	#	cp "${FILESDIR}/gir-paxctl-lt-wrapper" "${S}/" || die
	#fi

	# We need to reset some variables to prevent permissions problems and failures
	# like https://bugs.webkit.org/show_bug.cgi?id=35471 and bug #323669
	gnome2_environment_reset

	# Failing tests
	# * webinspector -> https://bugs.webkit.org/show_bug.cgi?id=50744
	# * keyevents is interactive
	# * mimehandling test sometimes fails under Xvfb (works fine manually), bug #????
	# * webdatasource test needs a network connection and intermittently fails with icedtea-web
	# * webplugindatabase intermittently fails with icedtea-web, bug #????
	sed -e '/Programs\/unittests\/testwebinspector/ d' \
		-e '/Programs\/unittests\/testkeyevents/ d' \
		-e '/Programs\/unittests\/testmimehandling/ d' \
		-e '/Programs\/unittests\/testwebdatasource/ d' \
		-e '/Programs\/unittests\/testwebplugindatabase/ d' \
		-i Source/WebKit/gtk/GNUmakefile.am || die

	if ! use gstreamer; then
		# webkit2's TestWebKitWebView requires <video> support, bug #????
		sed -e '/Programs\/WebKit2APITests\/TestWebKitWebView/ d' \
			-i Source/WebKit2/UIProcess/API/gtk/tests/GNUmakefile.am || die
	fi

	# Test if it fixed
	# garbage collection test fails intermittently if icedtea-web is installed, bug #????
	#epatch "${FILESDIR}/${PN}-1.7.90-test_garbage_collection.patch"

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# bug #459978, upstream bug #113397
	epatch "${FILESDIR}/${PN}-1.11.90-gtk-docize-fix.patch"

	# Test if fixed
	# Do not build unittests unless requested
	#epatch "${FILESDIR}"/${PN}-2.2.2-unittests-build.patch

	# upstream bug #128080
	epatch "${FILESDIR}/${PN}-2.3.4-install.patch"

	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=Source/autotools eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this in LDFLAGS, bug #????
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co., bug #????
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# Try to use less memory, bug #469942
	append-ldflags "-Wl,--no-keep-memory"

	local myconf=""

	if has_version "virtual/rubygems[ruby_targets_ruby20]"; then
		myconf="${myconf} RUBY=$(type -P ruby20)"
	elif has_version "virtual/rubygems[ruby_targets_ruby19]"; then
		myconf="${myconf} RUBY=$(type -P ruby19)"
	else
		myconf="${myconf} RUBY=$(type -P ruby18)"
	fi

	# TODO: Check Web Audio support
	# should somehow let user select between them?
	#
	# * Aqua support in gtk3 is untested
	# * dependency-tracking is required so parallel builds won't fail
	econf \
		$(use_enable coverage) \
		$(use_enable debug) \
		$(use_enable egl) \
		$(use_enable geoloc geolocation) \
		$(use_enable gles2) \
		$(use_enable gstreamer video) \
		$(use_enable introspection) \
		$(use_enable jit) \
		$(use_enable libsecret credential_storage) \
		$(use_enable opengl glx) \
		$(use_enable spell spellcheck) \
		$(use_enable webgl) \
		$(use_enable webgl accelerated-compositing) \
		--with-gtk=3.0 \
		--enable-dependency-tracking \
		--disable-gtk-doc \
		$(usex aqua "--with-font-backend=pango --with-target=quartz" "")
		${myconf}
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
	newdoc Source/JavaScriptCore/ChangeLog ChangeLog.JavaScriptCore
	newdoc Source/WebCore/ChangeLog ChangeLog.WebCore

	prune_libtool_files

	# Prevents crashes on PaX systems
	use jit && pax-mark m "${ED}usr/bin/jsc-3"
}

nvidia_check() {
	if [[ ${MERGE_TYPE} != "binary" ]] &&
	   use introspection &&
	   has_version '=x11-drivers/nvidia-drivers-325*' &&
	   [[ $(eselect opengl show 2> /dev/null) = "nvidia" ]]
	then
		eerror "${PN} freezes while compiling if x11-drivers/nvidia-drivers-325.* is"
		eerror "used as the system OpenGL library."
		eerror "You can either update to >=nvidia-drivers-331.13, or temporarily select"
		eerror "Mesa as the system OpenGL library:"
		eerror " # eselect opengl set xorg-x11"
		eerror "See https://bugs.gentoo.org/463960 for more details."
		eerror
		return 1
	fi
}
