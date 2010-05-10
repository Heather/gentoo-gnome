# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils gnome2 virtualx

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://www.gnome.org/projects/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +hal policykit test"

# FIXME: Interactive testsuite (upstream ? I'm so...pessimistic)
RESTRICT="test"

# HAL is used purely as a fallback for setting brightness if xrandr fail
COMMON_DEPEND=">=dev-libs/glib-2.13.0
	>=x11-libs/gtk+-2.17.7
	>=gnome-base/gconf-2.10.0
	>=gnome-base/gnome-keyring-0.6.0
	>=dev-libs/dbus-glib-0.71
	>=x11-libs/libnotify-0.4.3
	>=x11-libs/libwnck-2.10.0
	>=x11-libs/cairo-1.0.0
	>=gnome-base/gnome-panel-2
	>=gnome-base/gconf-2.10
	>=media-libs/libcanberra-0.10[gtk]
	|| ( sys-power/upower >=sys-apps/devicekit-power-008 )
	>=dev-libs/libunique-1.1.0
	>=x11-apps/xrandr-1.2
	x11-libs/libX11
	x11-libs/libXext

	hal? ( >=sys-apps/hal-0.5.9 )
"
RDEPEND="${COMMON_DEPEND}
	>=sys-auth/consolekit-0.4[policykit?]
	policykit? ( gnome-extra/polkit-gnome )
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
		--enable-applets"

	if ! use hal; then
		ewarn "hal support disabled, cpufreq applet will not be built"
	fi
}

src_prepare() {
	gnome2_src_prepare

	# Fix crazy cflags
	sed 's:-DG.*DISABLE_DEPRECATED::g' -i configure.ac configure \
		|| die "sed 1 failed"

	# Drop debugger CFLAGS
	sed -e 's:^CPPFLAGS="$CPPFLAGS -g"$::g' -i configure.ac \
		|| die "sed 2 failed"

	# Drop test that needs a running daemon
	sed 's:^\(.*gpm_inhibit_test (test);\)://\1:' -i src/gpm-self-test.c \
		|| die "sed 3 failed"

	# Make it libtool-1 compatible
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	if ! use doc; then
		# Remove the docbook2man rules here since it's not handled by a proper
		# parameter in configure.in.
		sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' \
			-i "${S}/man/Makefile.in" || die "sed 4 failed"
	fi

	# glibc splits this out, whereas other libc's do not tend to
	use elibc_glibc || sed -e 's/-lresolv//' -i configure || die "sed 5 failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "cpufreq capplet is a feature maintained by Gentoo GNOME team."
	elog "Please DO NOT REPORT bugs on upstream bugzilla if you have a problem with it"
	elog "Please report on http://bugs.gentoo.org instead."

	if use hal; then
		elog
		elog "To enable frequency scaling interface, use the following command:"
		elog "	gconftool-2 /apps/gnome-power-manager/ui/cpufreq_show"
		elog "Note that this will conflict with other power managment utility"
		elog "like app-laptop/laptop-mode-tools."
	fi
}
