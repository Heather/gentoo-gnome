# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-power-manager/gnome-power-manager-2.26.4.ebuild,v 1.1 2009/08/09 18:31:49 eva Exp $

EAPI="2"

inherit autotools eutils gnome2 virtualx

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://www.gnome.org/projects/gnome-power-manager/"
#TODO: Finish the patchset including translations updates
# (that's why this patch isn't on a mirror yet)
SRC_URI="${SRC_URI}
	http://dev.gentoo.org/~mrpouet/pub/patches/${P}-cpufreq-patches.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +hal policykit test"

# See bug #196490 & bug #575500
#RESTRICT="test"

# HAL is used purely as a fallback for setting brightness if xrandr fail
COMMON_DEPEND=">=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.11.0
	>=gnome-base/gconf-2.10.0
	>=gnome-base/gnome-keyring-0.6.0
	>=dev-libs/dbus-glib-0.71
	>=x11-libs/libnotify-0.4.3
	>=x11-libs/libwnck-2.10.0
	>=x11-libs/cairo-1.0.0
	>=gnome-base/gnome-panel-2
	>=gnome-base/gconf-2.10
	>=media-libs/libcanberra-0.10[gtk]
	>=sys-apps/devicekit-power-008
	>=dev-libs/libunique-1
	>=x11-apps/xrandr-1.2
	x11-libs/libX11
	x11-libs/libXext

	hal? ( >=sys-apps/hal-0.5.9 )
"
RDEPEND="${COMMON_DEPEND}
	gnome-extra/polkit-gnome
"
DEPEND="${COMMON_DEPEND}
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

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable hal)
		$(use_enable test tests)
		$(use_enable doc docbook-docs)
		$(use_enable policykit gconf-defaults)
		--enable-compile-warnings=minimum
		--with-dpms-ext
		--enable-applets"
}

src_prepare() {
	gnome2_src_prepare

	if ! use doc; then
		# Remove the docbook2man rules here since it's not handled by a proper
		# parameter in configure.in.
		sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' -i "${S}/man/Makefile.in" || die "sed 1 failed"
	fi

	# Drop debugger CFLAGS
	sed -e 's:^CPPFLAGS="$CPPFLAGS -g"$::g' -i configure.ac \
		|| die "sed 2 failed"

	# Drop test that needs a running daemon
	sed 's:^\(.*gpm_inhibit_test (test);\)://\1:' -i src/gpm-self-test.c \
		|| die "sed 3 failed"

	# Skip crazy compilation warnings, bug #263078
	epatch "${FILESDIR}/${PN}-2.26.0-gcc44-options.patch"

	# Resurrect cpufreq in capplet, bug #263891
	epatch "${WORKDIR}/${P}-cpufreq-libhal-glib.patch"
	epatch "${WORKDIR}/${P}-cpufreq-support.patch"
	epatch "${WORKDIR}/${P}-cpufreq-ui.patch"
#	epatch "${WORKDIR}/${PN}-2.26.3-cpufreq-po.patch"

	# Fix uninstalled cpufreq schemas, bug #266995
	epatch "${WORKDIR}/${P}-cpufreq-schemas.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"

	# Make it libtool-1 compatible
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"
	eautoreconf

	# glibc splits this out, whereas other libc's do not tend to
	use elibc_glibc || sed -e 's/-lresolv//' -i configure || die "sed 4 failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "Cpufreq capplet is now maintained by Gentoo GNOME team"
	elog "This implies DO NOT REPORT any bugs on upstream if you have a problem with it"
	elog "Please report on http://bugs.gentoo.org instead."
#	elog
#	elog "To enable frequency scaling interface, use the following command:"
#	elog "	gconftool-2 /apps/gnome-power-manager/ui/cpufreq_show"
#	elog "Note that this will conflict with other power managment utility"
#	elog "like app-laptop/laptop-mode-tools."
#	elog
}
