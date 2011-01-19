# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-power-manager/gnome-power-manager-2.32.0.ebuild,v 1.5 2010/12/12 16:53:55 armin76 Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils gnome2 virtualx

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://www.gnome.org/projects/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc test"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

# FIXME: Interactive testsuite (upstream ? I'm so...pessimistic)
RESTRICT="test"

# Latest libcanberra is needed due to gtk+:3 API changes
COMMON_DEPEND=">=dev-libs/glib-2.25.9
	>=x11-libs/gtk+-2.91.7:3
	>=gnome-base/gnome-keyring-0.6.0
	>=x11-libs/libnotify-0.7.0
	>=x11-libs/cairo-1.0.0
	>=gnome-base/gconf-2.31.1
	>=gnome-base/gnome-control-center-2.31.4
	>=media-libs/libcanberra-0.26-r2[gtk3]
	>=sys-power/upower-0.9.1
	>=x11-apps/xrandr-1.3
	>=x11-proto/xproto-7.0.15
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND="${COMMON_DEPEND}
	>=sys-auth/consolekit-0.4[policykit]
	sys-auth/polkit
	gnome-extra/polkit-gnome"
DEPEND="${COMMON_DEPEND}
	x11-proto/randrproto

	sys-devel/gettext
	app-text/scrollkeeper
	app-text/docbook-xml-dtd:4.3
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2
	doc? (
		app-text/xmlto
		app-text/docbook-sgml-utils
		app-text/docbook-xml-dtd:4.4
		app-text/docbook-sgml-dtd:4.1
		app-text/docbook-xml-dtd:4.1.2 )"

# docbook-sgml-utils and docbook-sgml-dtd-4.1 used for creating man pages
# (files under ${S}/man).
# docbook-xml-dtd-4.4 and -4.1.2 are used by the xml files under ${S}/docs.

src_prepare() {
	G2CONF="${G2CONF}
		$(use_enable test tests)
		$(use_enable doc docbook-docs)
		--enable-compile-warnings=minimum
		--disable-schemas-compile"
	DOCS="AUTHORS ChangeLog NEWS README TODO"

	# Should get merged soonish, remove from live version after that
	# https://bugzilla.gnome.org/show_bug.cgi?id=639956
	epatch "${FILESDIR}/${P}-fix-schemas-migrate.patch"

	# Drop debugger CFLAGS from configure
	sed -e 's:^CPPFLAGS="$CPPFLAGS -g"$::g' \
		-i configure.ac configure || die "debugger sed failed"

	if ! use doc; then
		# Remove the docbook2man rules here since it's not handled by a proper
		# parameter in configure.in.
		sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' \
			-i man/Makefile.am man/Makefile.in \
			|| die "docbook sed failed"
	fi

	# glibc splits this out, whereas other libc's do not tend to
	if use elibc_glibc; then
		sed -e 's/-lresolv//' \
			-i configure.ac configure || die "resolv sed failed"
	fi

	if [[ ${PV} != 9999 ]]; then
		# FIXME: This is required to prevent maintainer mode after "debugger sed"
		intltoolize --force --copy --automake || die "intltoolize failed"
		eautoreconf
	fi

	gnome2_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch Xemake check || die "Test phase failed"
}
