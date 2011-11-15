# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-2.32.1.1.ebuild,v 1.2 2011/01/24 15:51:47 eva Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit gnome2 flag-o-matic multilib python

DESCRIPTION="A versatile IDE for GNOME"
HOMEPAGE="http://www.anjuta.org"
SRC_URI="${SRC_URI} mirror://gentoo/introspection.m4.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="debug devhelp doc glade graphviz +introspection packagekit subversion test vala"

# FIXME: tests are fragile and may require a specific set of USE flags
#RESTRICT="test"

# FIXME: documentation fails to build when USE=test. But why?
REQUIRED_USE="test? ( !doc )"

COMMON_DEPEND=">=dev-libs/glib-2.29.2:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.0.0:3
	>=x11-libs/vte-0.27.6:2.90
	>=dev-libs/libxml2-2.4.23
	>=dev-libs/gdl-2.91.4:3
	>=x11-libs/gtksourceview-2.91.8:3.0

	sys-devel/autogen

	>=gnome-extra/libgda-4.99.0:5
	dev-util/ctags

	x11-libs/libXext
	x11-libs/libXrender

	devhelp? ( >=dev-util/devhelp-3.0.0 )
	glade? ( >=dev-util/glade-3.9.2:3.10 )
	graphviz? ( >=media-gfx/graphviz-2.6 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	subversion? (
		>=dev-vcs/subversion-1.5.0
		>=net-libs/neon-0.28.2
		>=dev-libs/apr-1
		>=dev-libs/apr-util-1 )
	vala? ( >=dev-lang/vala-0.13.3:0.14 )"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	!!dev-libs/gnome-build
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40.1
	>=dev-util/pkgconfig-0.22
	>=app-text/scrollkeeper-0.3.14-r2
	>=app-text/gnome-doc-utils-0.18
	dev-util/gtk-doc-am
	gnome-base/gnome-common
	sys-devel/bison
	sys-devel/flex
	doc? ( >=dev-util/gtk-doc-1.4 )
	test? (
		~app-text/docbook-xml-dtd-4.1.2
		~app-text/docbook-xml-dtd-4.5 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog FUTURE MAINTAINERS NEWS README ROADMAP THANKS TODO"

	G2CONF="${G2CONF}
		VALAC=$(type -P valac-0.14)
		--disable-static
		--disable-schemas-compile
		--docdir=/usr/share/doc/${PF}
		$(use_enable debug)
		$(use_enable devhelp plugin-devhelp)
		$(use_enable glade plugin-glade)
		$(use_enable graphviz)
		$(use_enable introspection)
		$(use_enable packagekit)
		$(use_enable subversion plugin-subversion)
		$(use_enable vala)"

	# Conflics with -pg in a plugin, bug #266777
	filter-flags -fomit-frame-pointer

	python_pkg_setup
	python_set_active_version 2
}

#src_prepare() {
#	gnome2_src_prepare

	# Needed to preserve introspection configure option, see bgo#633730
	# eautoreconf needs introspection.m4
	#
	# Looks to not be needed for this version, but, if introspection configure
	# option is lost again, revisit this.
#	cp "${WORKDIR}"/introspection.m4 . || die
#	intltoolize --force --copy --automake || die "intltoolize failed"
#	AT_M4DIR="." eautoreconf
#}

src_install() {
	# Anjuta uses a custom rule to install DOCS, get rid of it
	gnome2_src_install
	rm -rf "${ED}"/usr/share/doc/${PN} || die "rm failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog ""
	elog "Some project templates may require additional development"
	elog "libraries to function correctly. It goes beyond the scope"
	elog "of this ebuild to provide them."

	if use vala; then
		elog ""
		elog "To create a generic vala project you will need to specify"
		elog "desired valac versioned binary to be used, to do that you"
		elog "will need to:"
		elog "1. Go to 'Build' -> 'Configure project'"
		elog "2. Add 'VALAC=/usr/bin/valac-X.XX' (respecting quotes) to"
		elog "'Configure options'."
	fi
}
