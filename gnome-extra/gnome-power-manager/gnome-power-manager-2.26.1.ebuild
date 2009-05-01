# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-power-manager/gnome-power-manager-2.22.1.ebuild,v 1.8 2008/08/10 12:44:55 maekke Exp $

EAPI="2"

inherit autotools eutils gnome2 virtualx

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://www.gnome.org/projects/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="doc policykit test"

# See bug #196490 & bug #575500
RESTRICT="test"

# dev-libs/libunique needs KEYWORDS
RDEPEND=">=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.11.0
	>=gnome-base/gnome-keyring-0.6.0
	>=sys-apps/hal-0.5.9[policykit?]
	>=dev-libs/dbus-glib-0.71
	>=gnome-base/libglade-2.5.0
	>=x11-libs/libnotify-0.4.3
	>=x11-libs/libwnck-2.10.0
	>=x11-libs/cairo-1.0.0
	>=gnome-base/gnome-panel-2
	>=gnome-base/gconf-2
	>=media-libs/libcanberra-0.10[gtk]
	>=sys-apps/devicekit-001
	>=sys-apps/devicekit-power-005
	>=dev-libs/libunique-1

	>=x11-apps/xrandr-1.2
	x11-libs/libX11
	x11-libs/libXext

	policykit? ( >=sys-auth/policykit-0.8 )"
DEPEND="${RDEPEND}
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
		$(use_enable test tests)
		$(use_enable doc docbook-docs)
		$(use_enable policykit)
		$(use_enable policykit gconf-defaults)
		--enable-compile-warnings=minimum
		--with-dpms-ext
		--disable-legacy-buttons
		--enable-applets"
	# XXX: --disable-legacy-buttons => only xevents => newer Xorg
}

src_prepare() {
	gnome2_src_prepare

	if ! use doc; then
		# Remove the docbook2man rules here since it's not handled by a proper
		# parameter in configure.in.
		sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' -i "${S}/man/Makefile.in" || die "sed 1 failed"
	fi

	# Skip crazy compilation warnings, bug #263078
	epatch "${FILESDIR}/${PN}-2.26.0-gcc44-options.patch"

	# Resurrect cpufreq in capplet, bug #263891
	epatch "${FILESDIR}/${PN}-2.26.0-cpufreq-libhal-glib.patch"
	epatch "${FILESDIR}/${PN}-2.26.0-cpufreq-support.patch"
	epatch "${FILESDIR}/${PN}-2.26.0-cpufreq-ui.patch"
	epatch "${FILESDIR}/${PN}-2.26.1-cpufreq-po.patch"

	# Fix uninstalled cpufreq schemas, bug #266995
	epatch "${FILESDIR}/${PN}-2.26.0-cpufreq-schemas.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"

	# Make it libtool-1 compatible
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"
	eautoreconf

	# glibc splits this out, whereas other libc's do not tend to
	use elibc_glibc || sed -e 's/-lresolv//' -i configure || die "sed 2 failed"
}

src_test() {
	Xemake check || die "Test phase failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog
	elog "To enable frequency scaling interface, use the following command:"
	elog "	gconftool-2 /apps/gnome-power-manager/ui/cpufreq_show"
	elog "Note that this will conflict with other power managment utility"
	elog "like app-laptop/laptop-mode-tools."
	elog
}
