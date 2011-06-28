# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"
PYTHON_DEPEND="2"

inherit autotools gnome.org libtool eutils flag-o-matic pax-utils python virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"
SRC_URI="${SRC_URI}
	http://pkgconfig.freedesktop.org/releases/pkg-config-0.26.tar.gz" # pkg.m4 for eautoreconf

LICENSE="LGPL-2"
SLOT="2"
IUSE="debug doc fam +introspection selinux +static-libs test xattr"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
fi

RDEPEND="virtual/libiconv
	>=dev-libs/libffi-3.0.0
	sys-libs/zlib
	xattr? ( sys-apps/attr )
	fam? ( virtual/fam )"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.11
	>=dev-util/gtk-doc-am-1.15
	doc? (
		>=dev-libs/libxslt-1.0
		>=dev-util/gtk-doc-1.15
		~app-text/docbook-xml-dtd-4.1.2 )
	test? ( dev-util/pkgconfig
		>=sys-apps/dbus-1.2.14 )
	!<dev-util/gtk-doc-1.15-r2"
PDEPEND="introspection? ( dev-libs/gobject-introspection )
	!<gnome-base/gvfs-1.6.4-r990" # Earlier versions do not work with glib

# XXX: Consider adding test? ( sys-devel/gdb ); assert-msg-test tries to use it

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	[[ ${PV} = 9999 ]] && gnome2-live_src_prepare
	mv -vf "${WORKDIR}"/pkg-config-*/pkg.m4 "${WORKDIR}"/ || die

	if use ia64 ; then
		# Only apply for < 4.1
		local major=$(gcc-major-version)
		local minor=$(gcc-minor-version)
		if (( major < 4 || ( major == 4 && minor == 0 ) )); then
			epatch "${FILESDIR}/glib-2.10.3-ia64-atomic-ops.patch"
		fi
	fi

	# Don't fail gio tests when ran without userpriv, upstream bug 552912
	# This is only a temporary workaround, remove as soon as possible
	epatch "${FILESDIR}/${PN}-2.18.1-workaround-gio-test-failure-without-userpriv.patch"

	# Fix gmodule issues on fbsd; bug #184301
	epatch "${FILESDIR}"/${PN}-2.12.12-fbsd.patch

	# Fix test failure when upgrading from 2.22 to 2.24, upstream bug 621368
	epatch "${FILESDIR}/${PN}-2.24-assert-test-failure.patch"

	# Do not try to remove files on live filesystem, upstream bug #619274
	sed 's:^\(.*"/desktop-app-info/delete".*\):/*\1*/:' \
		-i "${S}"/gio/tests/desktop-app-info.c || die "sed failed"

	# Disable tests requiring dev-util/desktop-file-utils when not installed, bug #286629
	if ! has_version dev-util/desktop-file-utils ; then
		ewarn "Some tests will be skipped due dev-util/desktop-file-utils not being present on your system,"
		ewarn "think on installing it to get these tests run."
		sed -i -e "/appinfo\/associations/d" gio/tests/appinfo.c || die
		sed -i -e "/desktop-app-info\/default/d" gio/tests/desktop-app-info.c || die
		sed -i -e "/desktop-app-info\/fallback/d" gio/tests/desktop-app-info.c || die
		sed -i -e "/desktop-app-info\/lastused/d" gio/tests/desktop-app-info.c || die
	fi

	# Disable tests requiring dev-python/dbus-python, bug #349236
	if ! has_version dev-python/dbus-python ; then
		ewarn "Some tests will be skipped due dev-python/dbus-python not being present on your system,"
		ewarn "think on installing it to get these tests run."
		sed -i -e "/connection\/filter/d" gio/tests/gdbus-connection.c || die
		sed -i -e "/connection\/large_message/d" gio/tests/gdbus-connection-slow.c || die
		sed -i -e "/gdbus\/proxy/d" gio/tests/gdbus-proxy.c || die
		sed -i -e "/gdbus\/bus-watch-name/d" gio/tests/gdbus-names.c || die
		sed -i -e "/gdbus\/proxy-well-known-name/d" gio/tests/gdbus-proxy-well-known-name.c || die
		sed -i -e "/gdbus\/introspection-parser/d" gio/tests/gdbus-introspection.c || die
		sed -i -e "/gdbus\/method-calls-in-thread/d" gio/tests/gdbus-threading.c || die
	fi

	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	# Needed for the punt-python-check patch, disabling timeout test
	# Also needed to prevent croscompile failures, see bug #267603
	AT_M4DIR="${WORKDIR}" eautoreconf

	[[ ${CHOST} == *-freebsd* ]] && elibtoolize

	epunt_cxx
}

src_configure() {
	local myconf

	# Building with --disable-debug highly unrecommended.  It will build glib in
	# an unusable form as it disables some commonly used API.  Please do not
	# convert this to the use_enable form, as it results in a broken build.
	# -- compnerd (3/27/06)
	use debug && myconf="--enable-debug"

	# Always use internal libpcre, bug #254659
	econf ${myconf} \
		$(use_enable xattr) \
		$(use_enable doc man) \
		$(use_enable doc gtk-doc) \
		$(use_enable fam) \
		$(use_enable selinux) \
		$(use_enable static-libs static) \
		--enable-regex \
		--with-pcre=internal \
		--with-threads=posix \
		--disable-dtrace \
		--disable-systemtap
}

src_install() {
	local f
	emake DESTDIR="${D}" install || die "Installation failed"

	# Do not install charset.alias even if generated, leave it to libiconv
	rm -f "${ED}/usr/lib/charset.alias"

	# Don't install gdb python macros, bug 291328
	rm -rf "${ED}/usr/share/gdb/" "${ED}/usr/share/glib-2.0/gdb/"

	# This is there for git snapshots and the live ebuild, bug 351966
	emake README || die "emake README failed"
	dodoc AUTHORS ChangeLog* NEWS* README || die "dodoc failed"

	insinto /usr/share/bash-completion
	for f in gdbus gsettings; do
		newins "${ED}/etc/bash_completion.d/${f}-bash-completion.sh" ${f} || die
	done
	rm -rf "${ED}/etc"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	export XDG_CONFIG_DIRS=/etc/xdg
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
	export G_DBUS_COOKIE_SHA1_KEYRING_DIR="${T}/temp"
	export XDG_DATA_HOME="${T}"
	unset GSETTINGS_BACKEND # bug 352451

	# Related test is a bit nitpicking
	mkdir "$G_DBUS_COOKIE_SHA1_KEYRING_DIR"
	chmod 0700 "$G_DBUS_COOKIE_SHA1_KEYRING_DIR"

	# Hardened: gdb needs this, bug #338891
	if host-is-pax ; then
		pax-mark -mr "${S}"/tests/.libs/assert-msg-test \
			|| die "Hardened adjustment failed"
	fi

	# Need X for dbus-launch session X11 initialization
	Xemake check || die "tests failed"
}

pkg_preinst() {
	# Only give the introspection message if:
	# * The user has it enabled
	# * Has glib already installed
	# * Previous version was different from new version
	if use introspection && has_version "${CATEGORY}/${PN}"; then
		if ! has_version "=${CATEGORY}/${PF}"; then
			ewarn "You must rebuild gobject-introspection so that the installed"
			ewarn "typelibs and girs are regenerated for the new APIs in glib"
		fi
	fi
}

pkg_postinst() {
	# Inform users about possible breakage when updating glib and not dbus-glib, bug #297483
	if has_version dev-libs/dbus-glib; then
		ewarn "If you experience a breakage after updating dev-libs/glib try"
		ewarn "rebuilding dev-libs/dbus-glib"
	fi
}
