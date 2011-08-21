# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes"
SUPPORT_PYTHON_ABIS="1"
# XXX: is this still true?
# pygobject is partially incompatible with Python 3.
# PYTHON_DEPEND="2:2.6 3:3.1"
# RESTRICT_PYTHON_ABIS="2.4 2.5 3.0 *-jython"
PYTHON_DEPEND="2:2.6"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.* *-jython"

# XXX: Is the alternatives stuff needed anymore?
inherit alternatives autotools gnome2 python virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +cairo examples test +threads"
RESTRICT="test" # FIXME: tests require >=gobject-introspection-1.29.17

COMMON_DEPEND=">=dev-libs/glib-2.24.0:2
	>=dev-libs/gobject-introspection-0.10.2
	virtual/libffi
	cairo? ( >=dev-python/pycairo-1.10.0 )"
DEPEND="${COMMON_DEPEND}
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-libs/libxslt
		>=app-text/docbook-xsl-stylesheets-1.70.1 )
	test? (
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc )
	>=dev-util/pkgconfig-0.12"

# We now disable introspection support in slot 2 per upstream recommendation
# (see https://bugzilla.gnome.org/show_bug.cgi?id=642048#c9); however,
# older versions of slot 2 installed their own site-packages/gi, and
# slot 3 will collide with them.
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!!<dev-python/pygobject-2.28.6-r50:2[introspection]"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	# Hard-enable libffi support since both gobject-introspection and
	# glib-2.29.x rdepend on it anyway
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--with-ffi
		$(use_enable doc docs)
		$(use_enable cairo)
		$(use_with libffi ffi)
		$(use_enable threads thread)"
}

src_prepare() {
	gnome2_src_prepare

	# Drop site-packages/gtk-2.0/dsextras.py, it's installed by slot 2
	epatch "${FILESDIR}/${PN}-2.90.1-dsextras.py.patch"

	# Do not build tests if unneeded, bug #226345
	epatch "${FILESDIR}/${PN}-2.90.1-make_check.patch"

	# Support installation for multiple Python versions, upstream bug #648292
	epatch "${FILESDIR}/${PN}-2.90.1-support_multiple_python_versions.patch"

	# Rename doc directories to prevent file collision with slot 2
	epatch "${FILESDIR}/${PN}-2.90.1-rename-doc-directories.patch"
	if [[ ${PV} != 9999 ]]; then
		# rename and sed pre-built docs so devhelp can display them correctly
		mv docs/html/pygobject.devhelp docs/html/pygobject-3.0.devhelp || die
		sed -e 's:PyGObject Reference Manual:PyGObject 3.0 Reference Manual:' \
			-e 's:name="pygobject":name="pygobject-3.0":' \
			-i docs/html/pygobject-3.0.devhelp || die
		sed -e 's:href="pygobject/:href="pygobject-3.0/:g' \
			-i docs/html/index.sgml || die
	fi

	# Disable tests that fail
	#epatch "${FILESDIR}/${PN}-2.28.3-disable-failing-tests.patch"

	# disable pyc compiling
	ln -sfn $(type -P true) py-compile

	eautoreconf

	python_copy_sources
}

src_configure() {
	python_execute_function -s gnome2_src_configure
}

src_compile() {
	python_execute_function -d -s
}

# FIXME: With python multiple ABI support, tests return 1 even when they pass
src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	testing() {
		XDG_CACHE_HOME="${T}/$(PYTHON --ABI)"
		Xemake check PYTHON=$(PYTHON -a)
	}
	python_execute_function -s testing
}

src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image

	if use examples; then
		insinto /usr/share/doc/${P}
		doins -r examples || die "doins failed"
	fi
}

pkg_postinst() {
	python_mod_optimize gi
}

pkg_postrm() {
	python_mod_cleanup gi
}
